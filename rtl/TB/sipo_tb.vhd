----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/07/2022 10:43:43 PM
-- Design Name: 
-- Module Name: sipo_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sipo_tb is
--  Port ( );
end sipo_tb;

architecture Behavioral of sipo_tb is
    signal clk_s: std_logic;
    signal shift_s: std_logic;
    signal sereal_input_s: std_logic_vector(8-1 downto 0);
    signal parallel_output_s: std_logic_vector(24-1 downto 0);
    signal read_en_s: std_logic;
begin
    sipo_re:
    entity work.sipo_register
    generic map(
        WIDTH => 8,
        DEPTH => 3
    )
    port map(
        clk => clk_s,
        shift => shift_s,
        sereal_input => sereal_input_s,
        parallel_output => parallel_output_s,
        read_en => read_en_s
    );
    
    clk_gen: process
    begin
        clk_s <= '0', '1' after 50 ns;
        wait for 100 ns;
    end process;
    
    dut: process
    begin
        sereal_input_s <= "10101010", "11001100" after 100 ns, "10011001" after 200 ns, "01010101" after 500 ns, "00110011" after 600 ns, "01100110" after 700 ns;
        shift_s <= '0', '1' after 30 ns, '0' after 280 ns,  '1' after 530 ns, '0' after 780 ns;
        wait;
    end process;
end Behavioral;
