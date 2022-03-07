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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity piso_register is
    generic (
        WIDTH : positive := 8;
        DEPTH : positive := 3
    );
    port (
        clk : in std_logic;
        write_en : in std_logic;
        shift_in : in std_logic;
        reset_in : in std_logic;
        parallel_0_in : in std_logic_vector (WIDTH - 1 downto 0);
        parallel_1_in : in std_logic_vector (WIDTH - 1 downto 0);
        parallel_2_in : in std_logic_vector (WIDTH - 1 downto 0);
        sereal_output : out std_logic_vector(WIDTH - 1 downto 0)
    );
end piso_register;

architecture Behavioral of piso_register is
    signal state_s : std_logic_vector(DEPTH * WIDTH - 1 downto 0);
    type shift_t is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
    signal shift_reg_s : shift_t;
    constant DEPTH_c : integer := DEPTH - 1;
begin

    piso_reg : process (clk) is
    begin
        if rising_edge(clk) then
            if reset_in = '1' then
                shift_reg_s(0) <= (others => '0');
                shift_reg_s(1) <= (others => '0');
                shift_reg_s(2) <= (others => '0');
            elsif write_en = '1' then
                --state_s <= parallel_input;
                shift_reg_s(0) <= parallel_0_in;
                shift_reg_s(1) <= parallel_1_in;
                shift_reg_s(2) <= parallel_2_in;
            elsif shift_in = '1' then
                sereal_output <= shift_reg_s(2);
                shift_reg_s(2) <= shift_reg_s(1);
                shift_reg_s(1) <= shift_reg_s(0);
                shift_reg_s(0) <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;