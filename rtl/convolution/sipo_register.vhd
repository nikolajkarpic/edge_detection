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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sipo_register is
    generic (
        DEPTH : positive := 3;
        WIDTH : positive := 8
    );
    port (
        clk : in std_logic;
        shift : in std_logic;
        reset_in : in std_logic;
        sereal_input : in std_logic_vector(WIDTH - 1 downto 0);
        --parallel_output: out std_logic_vector(DEPTH*WIDTH-1 downto 0);
        parallel_0_out : out std_logic_vector(WIDTH - 1 downto 0);
        parallel_1_out : out std_logic_vector(WIDTH - 1 downto 0);
        parallel_2_out : out std_logic_vector(WIDTH - 1 downto 0);
        read_en : out std_logic
    );
end sipo_register;

architecture Behavioral of sipo_register is
    signal en_gen_s : std_logic_vector(DEPTH - 1 downto 0) := (0 => '1',
    others => '0');
    signal state_s : std_logic_vector(DEPTH * WIDTH - 1 downto 0) := (others => '0');
begin
    sipo_reg : process (clk) is
    begin
        if rising_edge(clk) then
            if shift = '1' then
                en_gen_s <= en_gen_s(0) & en_gen_s(DEPTH - 1 downto 1);
                state_s <= sereal_input & state_s(DEPTH * WIDTH - 1 downto WIDTH);
            elsif reset_in = '1' then
                state_s <= (others => '0');
                en_gen_s <= (others => '0');
            end if;
        end if;
    end process;

    parallel_0_out <= state_s(DEPTH * WIDTH - 1 downto (DEPTH - 1) * WIDTH);
    parallel_1_out <= state_s((DEPTH - 1) * WIDTH - 1 downto (DEPTH - 2) * WIDTH);
    parallel_2_out <= state_s((DEPTH - 2) * WIDTH - 1 downto (DEPTH - 3) * WIDTH);
    read_en <= en_gen_s(0);
    --parallel_output <= state_s;   
end Behavioral;