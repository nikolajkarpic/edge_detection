----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/01/2022 04:48:42 PM
-- Design Name: 
-- Module Name: PISO - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PISO_down is
    generic (
        DATA_WIDTH : natural := 9;
        N_in : natural := 3
    );
    port (
        --------------- Clocking and reset interface ---------------
        clk_i : in std_logic;
        reset_in : in std_logic;

        ------------------- Input data interface -------------------
        shift_i : in std_logic;
        write_en_i : in std_logic;
        data_i : in std_logic_vector(N_in * DATA_WIDTH - 1 downto 0);
        data_s_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        MAC_en_o: out std_logic;
        ------------------- Output data interface -------------------
        data_s_o : out std_logic_vector(DATA_WIDTH - 1 downto 0)

    );
end PISO_down;

architecture Behavioral of PISO_down is

    type reg_type is array(0 to N_in - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal reg : reg_type;
begin

    process (clk_i) is
    begin
        if (rising_edge(clk_i)) then
            if (reset_in = '1') then
                reg <= (others => (others => '0'));
            else
                if (write_en_i = '1') then
                    for i in 0 to N_in - 1 loop
                        reg(i) <= data_i((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH);
                    end loop;
                else
                    if (shift_i = '1') then
                        for i in N_in - 1 downto 1 loop
                            reg(i) <= reg(i - 1);
                            if(i = 2) then
                                MAC_en_o <= '1';
                            else
                            MAC_en_o <= '0';
                            end if;
                        end loop;
                        reg(0) <= data_s_i;
                    end if;
                end if;
            end if;
        end if;

    end process;

    data_s_o <= reg(N_in - 1);
end Behavioral;