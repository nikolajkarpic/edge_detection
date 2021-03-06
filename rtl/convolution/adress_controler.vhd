----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/31/2021 01:02:07 PM
-- Design Name: 
-- Module Name: adress_controler - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity adress_controler is
    generic (
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : natural := 9; -- widht/height of kernel
        WIDTH_kernel_size : natural := 4; --Number of bits needed to reporesent kernel size
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        clk : in std_logic; -- clock
        reset_in : in std_logic; -- reset
        calc_adr_i : in std_logic; -- enable for calculating pixel and kernel addreses
        calc_conv_adr_i : in std_logic; -- enable for calculating output adress
        shift_en_in : in std_logic; -- enable that shifts out addresses to bram to get data from it
        i_i : in std_logic_vector(WIDTH_img_size - 1 downto 0); -- FSM counters whith which addresses are calculated
        j_i : in std_logic_vector(WIDTH_img_size - 1 downto 0);
        k_i : in std_logic_vector(WIDTH_kernel_size - 1 downto 0);
        l_i : in std_logic_vector(WIDTH_kernel_size - 1 downto 0);

        conv_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0); -- output addresss

        kernel_0_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0); -- kernel addresses
        kernel_1_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_2_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);

        bram_shifted_out : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0); -- addresses that are shifted out to bram
        bram_read_en_out : out std_logic -- read enable for bram
    );
end adress_controler;

architecture Behavioral of adress_controler is

    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    signal pixel_0_adr_s, pixel_1_adr_s, pixel_2_adr_s, pixel_0_adr_next_s, pixel_1_adr_next_s, pixel_2_adr_next_s, conv_adr_s, conv_adr_next_s : std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
    signal kernel_0_adr_s, kernel_1_adr_s, kernel_2_adr_s, kernel_0_adr_next_s, kernel_1_adr_next_s, kernel_2_adr_next_s : std_logic_vector(WIDTH_kernel_adr - 1 downto 0);
    --signal pixel_adr_0_s, pixel_adr_1_s, pixel_adr_2_s, conv_adr_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);

    signal i_reg, j_reg, i_next, j_next : std_logic_vector(WIDTH_img_size - 1 downto 0);
    signal k_reg, l_reg, k_next, l_next : std_logic_vector(WIDTH_kernel_size - 1 downto 0);

    signal pixel_0_bram_adr_s, pixel_1_bram_adr_s, pixel_2_bram_adr_s : std_logic_vector (WIDTH_bram_in_out_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
    signal pixel_0_bram_slice_adr_s, pixel_1_bram_slice_adr_s, pixel_2_bram_slice_adr_s : std_logic_vector (WIDTH_num_of_pixels_in_bram - 1 downto 0);

    type shift_adr_reg_t is array (0 to 2) of std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
    signal adr_shift_reg : shift_adr_reg_t;
    signal bram_r_en_shift_reg : std_logic_vector(2 downto 0);

    --jul 12 22
    signal temp : std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);

begin
    -- combinational calculation of addresses
    -- calculates exact adress
    process (pixel_0_adr_next_s, pixel_1_adr_next_s, pixel_2_adr_next_s, i_reg, j_reg, k_reg, l_reg, conv_adr_next_s, i_i, j_i, k_i, l_i)
    begin
        pixel_0_adr_next_s <= std_logic_vector(((unsigned(i_i) + unsigned(k_i)) * DEFAULT_IMG_SIZE) + (unsigned(j_i) + unsigned(l_i)));
        pixel_1_adr_next_s <= std_logic_vector(((unsigned(i_i) + unsigned(k_i)) * DEFAULT_IMG_SIZE) + ((unsigned(j_i) + unsigned(l_i)) + 1));
        pixel_2_adr_next_s <= std_logic_vector(((unsigned(i_i) + unsigned(k_i)) * DEFAULT_IMG_SIZE) + ((unsigned(j_i) + unsigned(l_i)) + 2));

        conv_adr_next_s <= std_logic_vector((unsigned(i_i) * DEFAULT_IMG_SIZE) + unsigned(j_i));

        kernel_0_adr_next_s <= std_logic_vector((unsigned(k_i) * KERNEL_SIZE) + unsigned(l_i));
        kernel_1_adr_next_s <= std_logic_vector((unsigned(k_i) * KERNEL_SIZE) + (unsigned(l_i) + 1));
        kernel_2_adr_next_s <= std_logic_vector((unsigned(k_i) * KERNEL_SIZE) + (unsigned(l_i) + 2));
    end process;
    -- connects interfaces with addresses registers
    kernel_0_adr_o <= kernel_0_adr_s;
    kernel_1_adr_o <= kernel_1_adr_s;
    kernel_2_adr_o <= kernel_2_adr_s;

    --    bram_shifted_out <= adr_shift_reg(0); ///////12 jul 2022
    bram_shifted_out <= temp;

    bram_read_en_out <= bram_r_en_shift_reg(0);

    --address logic
    address_registers : process (clk)
    begin
        if (rising_edge(clk)) then
            --reset
            if (reset_in = '1') then
                pixel_0_adr_s <= (others => '0');
                pixel_1_adr_s <= (others => '0');
                pixel_2_adr_s <= (others => '0');
                -- shift registers for addreses
                adr_shift_reg <= (others => (others => '0'));
                bram_r_en_shift_reg <= (others => '0');

                conv_adr_s <= (others => '0');

                kernel_0_adr_s <= (others => '0');
                kernel_1_adr_s <= (others => '0');
                kernel_2_adr_s <= (others => '0');
            else
                -- shift register that feeds addresses to the bram module
                if (shift_en_in = '1') then
                    temp <= adr_shift_reg(0);
                    adr_shift_reg(0) <= adr_shift_reg(1);
                    adr_shift_reg(1) <= adr_shift_reg(2);

                    bram_r_en_shift_reg(0) <= bram_r_en_shift_reg(1);
                    bram_r_en_shift_reg(1) <= bram_r_en_shift_reg(2);
                    bram_r_en_shift_reg(2) <= '0';

                end if;
                -- write output address to register
                if (calc_conv_adr_i = '1') then
                    conv_adr_o <= conv_adr_next_s;
                end if;
                if (calc_adr_i = '1') then
                    -- puts addresses of pixels into shift reg which in turn will stream them in to BRAM adr in
                    adr_shift_reg(0) <= pixel_0_adr_next_s;
                    adr_shift_reg(1) <= pixel_1_adr_next_s;
                    adr_shift_reg(2) <= pixel_2_adr_next_s;
                    -- puts BRAM read en signal into shift reg.
                    bram_r_en_shift_reg <= (others => '1');

                    -- writes kernel addresses to registers
                    kernel_0_adr_s <= kernel_0_adr_next_s;
                    kernel_1_adr_s <= kernel_1_adr_next_s;
                    kernel_2_adr_s <= kernel_2_adr_next_s;

                end if;
            end if;
        end if;
    end process;
end Behavioral;