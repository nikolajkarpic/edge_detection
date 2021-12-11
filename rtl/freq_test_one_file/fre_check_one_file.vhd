----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2021 10:50:26 AM
-- Design Name: 
-- Module Name: fre_check_one_file - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY fre_check_one_file IS
    PORT (
        clk : IN STD_LOGIC;
        kernel_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        pixel_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        last_value : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
        out_1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END fre_check_one_file;

ARCHITECTURE Behavioral OF fre_check_one_file IS
    ATTRIBUTE use_dsp : STRING;
    ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";
    SIGNAL ker_x_pixel_s, last_plus_current_s : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL out_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF (rising_edge(clk)) THEN
            ker_x_pixel_s <= STD_LOGIC_VECTOR(Signed(kernel_in) * signed(pixel_in));
            last_plus_current_s <= STD_LOGIC_VECTOR (signed(ker_x_pixel_s) + signed(last_value));
            IF (last_plus_current_s(last_plus_current_s'left) = '1') THEN
                out_s <= "10";
            ELSE
                out_s <= "01";
            END IF;
        END IF;
        out_1 <= out_s;
    END PROCESS;

END Behavioral;