----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2021 12:07:16 PM
-- Design Name: 
-- Module Name: sign_checker - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY sign_checker IS
    -- GENERIC (
    --     WIDTHA : NATURAL := 24;
    --     WIDTHB : NATURAL := 32);
    PORT (
        clk : IN STD_LOGIC;
        in1 : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
        out1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END sign_checker;

ARCHITECTURE Behavioral OF sign_checker IS
    ATTRIBUTE use_dsp : STRING;
    ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";

    signal in_s: STD_LOGIC_VECTOR(23 DOWNTO 0);
    signal out_s: STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN

    process (clk) is
    begin
        if(rising_edge(clk)) then
            in_s <= in1;
            if( in_s(in_s'left) = '1' )then
                out_s <= "10";
            else
                out_s<= "01";
            end if;
        end if;
        out1<=out_s;
    end process;
END Behavioral;