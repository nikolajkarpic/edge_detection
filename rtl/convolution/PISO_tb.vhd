----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/07/2022 04:23:45 PM
-- Design Name: 
-- Module Name: PISO_tb - Behavioral
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

entity PISO_tb is
    generic(WIDTH: positive := 8;
    DEPTH: positive := 3);

end PISO_tb;

architecture Behavioral of PISO_tb is

    signal clk_s, shift_s, write_en_s : std_logic;
    signal parallel_input_s : std_logic_vector(DEPTH*WIDTH-1 downto 0);
    signal sereal_output_s : std_logic_vector(WIDTH-1 downto 0);

    component piso_register
        generic(
            WIDTH: positive := 8;
            DEPTH: positive := 3
        ); 
        port (
            clk: in std_logic;
            shift: in std_logic;
            write_en: in std_logic;
            parallel_input: in std_logic_vector(DEPTH*WIDTH-1 downto 0);
            sereal_output: out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

    constant m_clk : time := 2 ps;
    constant s_clk : time := 2 ps;

begin

    uut_piso_reg: piso_register port map(
        clk => clk_s,
        shift => shift_s,
        parallel_input => parallel_input_s,
        sereal_output => sereal_output_s,
        write_en => write_en_s
    );

    clk_process: process
    begin
        clk_s <= '0';
        wait for m_clk/2;
        clk_s <= '1';
        wait for m_clk/2;
    end process;

    stim_process: process
    begin



        write_en_s <= '1';

        parallel_input_s <= "000010000000010000000010";

        wait for 1 ns;

        write_en_s <= '0';

        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        write_en_s <= '1';

        parallel_input_s <= "100010001000010001000010";

        wait for 1 ns;

        write_en_s <= '0';

        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;

        shift_s <= '1';
        wait for 1 ns;

        shift_s <= '0';
        wait for 1 ns;


        wait;
    end process;

end Behavioral;
