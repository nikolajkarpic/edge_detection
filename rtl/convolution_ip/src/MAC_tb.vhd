-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 11.1.2022 16:41:23 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_MAC is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 24;
        SIGNED_UNSIGNED : string := "signed"
    );
end tb_MAC;

architecture tb of tb_MAC is

    component MAC
        port (
              rst_i       : in std_logic;
              en_in       : in std_logic;
              clk         : in std_logic;
              pixel_in    : in std_logic_vector (width_pixel - 1 downto 0);
              kernel_in   : in std_logic_vector (width_kernel - 1 downto 0);
              mul_acc_out : out std_logic_vector (width_sum - 1 downto 0));
    end component;

    signal sum_en_i    : std_logic;
    signal rst_i       : std_logic;
    signal en_in       : std_logic;
    signal clk         : std_logic;
    signal pixel_in    : std_logic_vector (width_pixel - 1 downto 0);
    signal kernel_in   : std_logic_vector (width_kernel - 1 downto 0);
    signal mul_acc_out : std_logic_vector (width_sum - 1 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : MAC
    port map (
              rst_i       => rst_i,
              en_in       => en_in,
              clk         => clk,
              pixel_in    => pixel_in,
              kernel_in   => kernel_in,
              mul_acc_out => mul_acc_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        sum_en_i <= '0';
        rst_i <= '1';
        en_in <= '0';
        pixel_in <="00000000" ;
        kernel_in <= "0000000000000000";
        wait for 2 * TbPeriod;
        rst_i <= '0';
        
        pixel_in <="00000001" ;
        kernel_in <= "0000000000000001";

        wait for 1 ns;

        en_in <= '1';

        wait for 3 * TbPeriod;
        -- pixel_in <="00000001" ;
        -- kernel_in <= "0000000000000001";
        -- en_in <= '1';

        wait for 2 * TbPeriod;

        -- en_in <= '0';

        -- wait for 5 * TbPeriod;

        pixel_in <="00000010" ;
        kernel_in <= "0000000000000101";
        -- en_in <= '1';

        wait for 5 * TbPeriod;
        -- en_in <= '0';

        --wait for 25 ns;

        pixel_in <="00000100" ;
        kernel_in <= "0000000000000011";
        en_in <= '0';

        wait for 5 * TbPeriod;

        --  en_in <= '0';
        --  rst_i <= '1';

        wait for 5 * TbPeriod;

        -- EDIT Add stimuli here
        wait for 10 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_MAC of tb_MAC is
    for tb
    end for;
end cfg_tb_MAC;