----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 11:50:39 AM
-- Design Name: 
-- Module Name: sipo_register - Behavioral
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

entity sipo_register is
    generic(
        DEPTH: positive:= 3;
        WIDTH: positive:= 8
    );
    port(
        clk: in std_logic;
        sereal_input: in std_logic_vector(WIDTH-1 downto 0);
        parallel_output: out std_logic_vector(DEPTH*WIDTH-1 downto 0);
        read_en: out std_logic
    );
end sipo_register;

architecture Behavioral of sipo_register is
    signal en_gen: std_logic_vector(DEPTH-1 downto 0) := (0 => '1',
                                                          others => '0');
    signal state_s: std_logic_vector(DEPTH*WIDTH-1 downto 0);
begin
    sipo_reg: process (clk) is
    begin
        if rising_edge(clk) then
            en_gen <= en_gen(0) & en_gen(DEPTH-1 downto 1);
            state_s <= sereal_input & state_s(DEPTH*WIDTH-1 downto WIDTH);
        end if;
    end process;
    
    read_en <= en_gen(0);
    parallel_output <= state_s;   
end Behavioral;
