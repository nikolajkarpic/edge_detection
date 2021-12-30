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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PB_group is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 32;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        rst_i : in std_logic;
        en_in : in std_logic;
        clk : in std_logic;
        pixel_0_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_1_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_2_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);

        sum_out_en : in std_logic;
        sum_out : out std_logic_vector(WIDTH_sum - 1 downto 0);

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
    signal rst_i_s, en_in_s, clk_s, sum_out_en_s : std_logic;

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
            rst_i : in std_logic;
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
            rst_i : in std_logic;
            en_in : in std_logic;
            clk : in std_logic;
            sum_0_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_1_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_2_in : in std_logic_vector(WIDTH_sum - 1 downto 0);
            sum_out : out std_logic_vector(WIDTH_sum - 1 downto 0)
        );

    end component;
begin
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
        rst_i => rst_i_s,
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
        rst_i => rst_i_s,
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
        rst_i => rst_i_s,
        pixel_in => pixel_2_in_s,
        kernel_in => kernel_2_in_s,
        mul_acc_out => mac_2_sum_s
    );

    SUM : accumulate_sum
    generic map(
        WIDTH_sum => WIDTH_sum,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map(
        en_in => sum_out_en_s,
        clk => clk_s,
        rst_i => rst_i_s,
        sum_0_in => mac_0_sum_s,
        sum_1_in => mac_1_sum_s,
        sum_2_in => mac_2_sum_s,
        sum_out => sum_out_reg_s
    );

    clk_s <= clk;
    rst_i_s <= rst_i;
    en_in_s <= en_in;
    sum_out_en_s <= sum_out_en;

    pixel_0_in_s <= pixel_0_in;
    pixel_1_in_s <= pixel_1_in;
    pixel_2_in_s <= pixel_2_in;

    kernel_0_in_s <= kernel_0_in;
    kernel_1_in_s <= kernel_1_in;
    kernel_2_in_s <= kernel_2_in;
    sum_out <= sum_out_reg_s;
end Behavioral;