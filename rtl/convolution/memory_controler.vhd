----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/31/2021 01:02:07 PM
-- Design Name: 
-- Module Name: memory_controler - Behavioral
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

entity memory_controler is
    generic (
        DEFAULT_IMG_SIZE : integer := 100;
        KERNEL_SIZE : integer := 9;
        WIDTH_img_size : integer := 7;
        WIDTH_kernel_size : integer := 4;
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 32;
        WIDTH_bram_in_out_adr : integer := 14;
        WIDTH_kernel_adr : integer := 6;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        clk : in std_logic;
        rst_i : in std_logic;
        calc_adr_i: in std_logic;
        calc_conv_adr_i: in std_logic;
        en_in : in std_logic;


        inc_i_i: in std_logic;
        inc_j_i: in std_logic;
        inc_k_i: in std_logic;
        inc_l_i: in std_logic;

        conv_adr_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);

        pixel_adr_0_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_adr_1_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_adr_2_o: out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0); 
        
        kernel_adr_0_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_adr_1_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_adr_2_o: out std_logic_vector (WIDTH_kernel_adr - 1 downto 0)

    );
end memory_controler;

architecture Behavioral of memory_controler is

    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    signal i_reg, j_reg, i_next, j_next : std_logic_vector(WIDTH_img_size - 1 downto 0);
    signal k_reg, l_reg, k_next, l_next : std_logic_vector(WIDTH_kernel_size - 1 downto 0);
    signal pixel_adr_0_s, pixel_adr_1_s, pixel_adr_2_s, conv_adr_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);

begin



    i_next <= std_logic_vector(unsigned(i_reg) + 1 ) when (inc_i_i = '1') else i_reg;
    j_next <= std_logic_vector(unsigned(j_reg) + 1 ) when (inc_j_i = '1') else j_reg;
    k_next <= std_logic_vector(unsigned(k_reg) + 1 ) when (inc_k_i = '1') else k_reg;
    l_next <= std_logic_vector(unsigned(l_reg) + 1 ) when (inc_l_i = '1') else l_reg; 

    


    process(clk)
    begin
        if (rising_edge(clk)) then
            if(rst_i = '1') then
                i_reg <= (others=>'0');
                j_reg <= (others=>'0');
                k_reg <= (others=>'0');
                l_reg <= (others=>'0');
            else
                i_reg <= i_next;
                j_reg <= j_next;
                k_reg <= k_next;
                l_reg <= l_next;
            end if;
        end if;
    end process;
end Behavioral;
