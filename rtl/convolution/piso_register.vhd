----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2022 08:37:02 AM
-- Design Name: 
-- Module Name: piso_register - Behavioral
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

entity piso_register is
    generic(
        WIDTH: positive := 8;
        DEPTH: positive := 3
    );
    Port (
        clk: in std_logic;
        shift: in std_logic;
        parallel_input: in std_logic_vector(DEPTH*WIDTH-1 downto 0);
        sereal_output: out std_logic_vector(WIDTH-1 downto 0)
    );
end piso_register;

architecture Behavioral of piso_register is
    signal state_s: std_logic_vector(DEPTH*WIDTH-1 downto 0);
begin
    piso_reg: process (clk) is
    begin
        if rising_edge(clk)then
            if shift = '0' then
                state_s <= parallel_input;
            else
                sereal_output <= state_s(WIDTH-1 downto 0);
                state_s(WIDTH*(DEPTH-1)-1 downto 0) <= state_s(WIDTH*DEPTH-1 downto WIDTH);
                state_s(WIDTH*DEPTH-1 downto WIDTH*(DEPTH-1)) <= (others=>'0');
            end if;
        end if;
    end process;
end Behavioral;
