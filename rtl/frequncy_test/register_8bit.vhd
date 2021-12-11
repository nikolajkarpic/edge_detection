----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2021 06:12:41 PM
-- Design Name: 
-- Module Name: register_8bit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY register_8bit IS
        GENERIC (
                WIDTH : NATURAL := 8
        );
        PORT (
                clk : IN STD_LOGIC;
                in1 : IN STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0);
                out1 : OUT STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0));
END register_8bit;

ARCHITECTURE Behavioral OF register_8bit IS
        ATTRIBUTE use_dsp : STRING;
        ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";
BEGIN
        reg : PROCESS (clk) IS
        BEGIN
                IF (rising_edge(clk)) THEN
                        out1 <= in1;
                END IF;
        END PROCESS;
END Behavioral;