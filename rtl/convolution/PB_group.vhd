----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nikolaj Karpic EE 142/2017
-- 
-- Create Date: 12/30/2021 03:31:31 PM
-- Design Name: PB_group
-- Module Name: PB_group - Behavioral
-- Project Name: edge_detection
-- Target Devices: zybo
-- Tool Versions: 
-- Description: combines 3 MAC units and a final sum unit. SIGN CHECK STILL NEEDS TO BE ADDED
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PB_group is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 32;
        WIDTH_conv : natural := 2;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        reset_in : in std_logic;
        en_in : in std_logic;
        clk : in std_logic;
        pixel_0_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_1_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_2_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);

        sum_out_en : in std_logic;
        sum_out : out std_logic_vector(WIDTH_sum - 1 downto 0);
        signed_out : out std_logic_vector(WIDTH_conv - 1 downto 0);
        -- for testing my band aid fix... it works ... line 183 184 
        -- en_for_sum_out : out std_logic;

        kernel_0_in : in std_logic_vector(WIDTH_kernel - 1 downto 0);
        kernel_1_in : in std_logic_vector(WIDTH_kernel - 1 downto 0);
        kernel_2_in : in std_logic_vector(WIDTH_kernel - 1 downto 0)

    );
end PB_group;

architecture Behavioral of PB_group is

    --signals
    signal mac_0_sum_s, mac_1_sum_s, mac_2_sum_s, sum_out_reg_s : std_logic_vector(WIDTH_sum - 1 downto 0);
    signal pixel_0_in_s, pixel_1_in_s, pixel_2_in_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal kernel_0_in_s, kernel_1_in_s, kernel_2_in_s : std_logic_vector(WIDTH_kernel - 1 downto 0);
    signal rst_i_s, en_in_s, clk_s, sum_out_en_s, sign_check_en : std_logic;
    signal signed_conv_out, signed_conv_out_n : std_logic_vector(WIDTH_conv - 1 downto 0);
    signal shift_reg : std_logic_vector (1 downto 0); -- for band aid fix 
    --components
    component MAC
        generic (
            WIDTH_pixel : natural := 8;
            WIDTH_kernel : natural := 16;
            WIDTH_sum : natural := 32;
            SIGNED_UNSIGNED : string := "signed"
        );
        port (
            sum_en_i : std_logic;
            reset_in : in std_logic;
            en_in : in std_logic;
            clk : in std_logic;
            pixel_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
            kernel_in : in std_logic_vector(WIDTH_kernel - 1 downto 0);
            mul_acc_out : out std_logic_vector(WIDTH_sum - 1 downto 0) --multiply accumulate 
        );
    end component;

    component accumulate_sum
        generic (
            WIDTH_sum : natural := 32;
            SIGNED_UNSIGNED : string := "signed"
        );
        port (
            reset_in : in std_logic;
            en_in : in std_logic;
            clk : in std_logic;
            sum_0_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_1_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_2_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_out : out std_logic_vector(WIDTH_sum - 1 downto 0)
        );

    end component;
begin
    -- three MAC units instanced and set up as to be connected to sumed and sign checked later
    MAC0 : MAC
    generic map(
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        WIDTH_sum => WIDTH_sum,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map
    (
        sum_en_i => sum_out_en_s,
        en_in => en_in_s,
        clk => clk_s,
        reset_in => rst_i_s,
        pixel_in => pixel_0_in_s,
        kernel_in => kernel_0_in_s,
        mul_acc_out => mac_0_sum_s
    );

    MAC1 : MAC
    generic map(
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        WIDTH_sum => WIDTH_sum,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map
    (
        sum_en_i => sum_out_en_s,
        en_in => en_in_s,
        clk => clk_s,
        reset_in => rst_i_s,
        pixel_in => pixel_1_in_s,
        kernel_in => kernel_1_in_s,
        mul_acc_out => mac_1_sum_s
    );

    MAC2 : MAC
    generic map(
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        WIDTH_sum => WIDTH_sum,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map
    (
        sum_en_i => sum_out_en_s,
        en_in => en_in_s,
        clk => clk_s,
        reset_in => rst_i_s,
        pixel_in => pixel_2_in_s,
        kernel_in => kernel_2_in_s,
        mul_acc_out => mac_2_sum_s
    );
    -- sums final results of the three MAC units
    SUM : accumulate_sum
    generic map(
        WIDTH_sum => WIDTH_sum,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map(
        en_in => sum_out_en_s,
        clk => clk_s,
        reset_in => rst_i_s,
        sum_0_in => mac_0_sum_s,
        sum_1_in => mac_1_sum_s,
        sum_2_in => mac_2_sum_s,
        sum_out => sum_out_reg_s
    );
    -- writes data to sign register and resets other registers and signals
    sign_check_seq : process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset_in = '1') then
                sign_check_en <= '0';
                signed_conv_out <= (others => '0');
            else
                -- band aid fix for pipelining the procces, it shifts data en for signed conv out by one clock cycle... signed conv out data lags behind sum out data by once clock.
                shift_reg(0) <= sum_out_en_s;
                shift_reg(1) <= shift_reg(0);
                if (shift_reg(1) = '1') then
                    signed_conv_out <= signed_conv_out_n;
                end if;
            end if;
        end if;

    end process;
    -- for testing my band aid fix... it works
    -- en_for_sum_out<=sign_check_en;
    
    -- checks the sign of the final sum 
    sign_check_comb : process (sum_out_reg_s, sign_check_en)
    begin
            if (signed(sum_out_reg_s) = 0) then
                signed_conv_out_n <= (others => '0'); -- 0 when sum is 0
            elsif (sum_out_reg_s(sum_out_reg_s'left) = '1') then
                signed_conv_out_n <= "10"; -- -1 when sum is < 0
            else
                signed_conv_out_n <= "01"; -- 1 when sum is > 0
            end if;
    end process;

    -- connects signals to interfaces
    clk_s <= clk;
    rst_i_s <= reset_in;
    en_in_s <= en_in;
    sum_out_en_s <= sum_out_en;

    pixel_0_in_s <= pixel_0_in;
    pixel_1_in_s <= pixel_1_in;
    pixel_2_in_s <= pixel_2_in;

    kernel_0_in_s <= kernel_0_in;
    kernel_1_in_s <= kernel_1_in;
    kernel_2_in_s <= kernel_2_in;
    sum_out <= sum_out_reg_s;
    signed_out <= signed_conv_out;
end Behavioral;