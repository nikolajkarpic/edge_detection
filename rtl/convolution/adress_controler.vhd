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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adress_controler is
    generic (
        DEFAULT_IMG_SIZE : integer := 100;
        WIDTH_img_size : integer := 7;
        KERNEL_SIZE : integer := 9;
        WIDTH_kernel_size : integer := 4;
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 32;
        WIDTH_bram_in_out_adr : integer := 14;
        WIDTH_kernel_adr : integer := 8;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        clk : in std_logic;
        rst_i : in std_logic;
        calc_adr_i: in std_logic;
        calc_conv_adr_i: in std_logic;
        en_in : in std_logic;


        i_i: in std_logic_vector(WIDTH_img_size - 1 downto 0);
        j_i: in std_logic_vector(WIDTH_img_size - 1 downto 0);
        k_i: in std_logic_vector(WIDTH_kernel_size - 1 downto 0);
        l_i: in std_logic_vector(WIDTH_kernel_size - 1 downto 0);

        conv_adr_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);

        pixel_0_adr_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_1_adr_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_2_adr_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0); 
        
        kernel_0_adr_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_1_adr_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_2_adr_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0)

    );
end adress_controler;

architecture Behavioral of adress_controler is

    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    signal pixel_0_adr_s, pixel_1_adr_s, pixel_2_adr_s, pixel_0_adr_next_s, pixel_1_adr_next_s, pixel_2_adr_next_s, conv_adr_s, conv_adr_next_s : std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
    signal kernel_0_adr_s, kernel_1_adr_s, kernel_2_adr_s, kernel_0_adr_next_s ,kernel_1_adr_next_s, kernel_2_adr_next_s : std_logic_vector(WIDTH_kernel_adr - 1 downto 0);
    --signal pixel_adr_0_s, pixel_adr_1_s, pixel_adr_2_s, conv_adr_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);

    signal i_reg, j_reg, i_next, j_next : std_logic_vector(WIDTH_img_size - 1 downto 0);
    signal k_reg, l_reg, k_next, l_next : std_logic_vector(WIDTH_kernel_size - 1 downto 0);

begin
    -- combinational calculation of addresses
    pixel_0_adr_next_s <= std_logic_vector((unsigned(i_reg) + unsigned(k_reg))*DEFAULT_IMG_SIZE + unsigned(j_reg) + unsigned(l_reg));
    pixel_1_adr_next_s <= std_logic_vector((unsigned(i_reg) + unsigned(k_reg))*DEFAULT_IMG_SIZE + unsigned(j_reg) + unsigned(l_reg) + 1);
    pixel_2_adr_next_s <= std_logic_vector((unsigned(i_reg) + unsigned(k_reg))*DEFAULT_IMG_SIZE + unsigned(j_reg) + unsigned(l_reg) + 2);

    conv_adr_next_s <= std_logic_vector((unsigned(i_reg) * DEFAULT_IMG_SIZE) + unsigned(j_reg));

    kernel_0_adr_next_s <= std_logic_vector((unsigned(k_reg) * KERNEL_SIZE) + unsigned(l_reg));
    kernel_1_adr_next_s <= std_logic_vector((unsigned(k_reg) * KERNEL_SIZE) + unsigned(l_reg) + 1);
    kernel_2_adr_next_s <= std_logic_vector((unsigned(k_reg) * KERNEL_SIZE) + unsigned(l_reg) + 2);

    --ker

    i_next <= i_i;
    j_next <= j_i;
    k_next <= k_i;
    l_next <= l_i;

    pixel_0_adr_o <= pixel_0_adr_s;
    pixel_1_adr_o <= pixel_1_adr_s;
    pixel_2_adr_o <= pixel_2_adr_s;

    conv_adr_o <= conv_adr_s;

    kernel_0_adr_o <= kernel_0_adr_s;
    kernel_1_adr_o <= kernel_1_adr_s;
    kernel_2_adr_o <= kernel_2_adr_s;

    --ovaj proces nisam siguran da valja
    address_registers:process(clk)
    begin
        if (rising_edge(clk)) then
            i_reg <= i_next;
            j_reg <= j_next;
            k_reg <= k_next;
            l_reg <= l_next;
            if(rst_i = '1') then
                i_reg <= (others=>'0');
                j_reg <= (others=>'0');
                k_reg <= (others=>'0');
                l_reg <= (others=>'0');

                pixel_0_adr_s <= (others=>'0');
                pixel_1_adr_s <= (others=>'0');
                pixel_2_adr_s <= (others=>'0');
                
                conv_adr_s <= (others=>'0');

                kernel_0_adr_s <= (others=>'0');
                kernel_1_adr_s <= (others=>'0');
                kernel_2_adr_s <= (others=>'0');
            elsif (calc_conv_adr_i = '1') then
                conv_adr_s <= conv_adr_next_s;
            elsif (calc_adr_i = '1') then
                pixel_0_adr_s <= pixel_0_adr_next_s;
                pixel_1_adr_s <= pixel_1_adr_next_s;
                pixel_2_adr_s <= pixel_2_adr_next_s;

                kernel_0_adr_s <= kernel_0_adr_next_s;
                kernel_1_adr_s <= kernel_1_adr_next_s;
                kernel_2_adr_s <= kernel_2_adr_next_s;

            end if;
        end if;
    end process;
end Behavioral;
