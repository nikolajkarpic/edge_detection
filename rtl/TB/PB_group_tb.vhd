-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 11.1.2022 15:09:12 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_PB_group is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 32;
        WIDTH_conv : natural := 2;
        SIGNED_UNSIGNED : string := "signed"
    );
end tb_PB_group;

architecture tb of tb_PB_group is

    component PB_group
        port (reset_in       : in std_logic;
              en_in       : in std_logic;
              clk         : in std_logic;
              pixel_0_in  : in std_logic_vector (width_pixel - 1 downto 0);
              pixel_1_in  : in std_logic_vector (width_pixel - 1 downto 0);
              pixel_2_in  : in std_logic_vector (width_pixel - 1 downto 0);
              sum_out_en  : in std_logic;
              sum_out     : out std_logic_vector (width_sum - 1 downto 0);
              signed_out : out std_logic_vector(WIDTH_conv - 1 downto 0);
              kernel_0_in : in std_logic_vector (width_kernel - 1 downto 0);
              kernel_1_in : in std_logic_vector (width_kernel - 1 downto 0);
              kernel_2_in : in std_logic_vector (width_kernel - 1 downto 0));
    end component;

    signal reset_in       : std_logic;
    signal en_in       : std_logic;
    signal clk         : std_logic;
    signal pixel_0_in  : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_1_in  : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_2_in  : std_logic_vector (width_pixel - 1 downto 0);
    signal sum_out_en  : std_logic;
    signal sum_out     : std_logic_vector (width_sum - 1 downto 0);
    signal signed_out : std_logic_vector(WIDTH_conv - 1 downto 0);
    signal kernel_0_in : std_logic_vector (width_kernel - 1 downto 0);
    signal kernel_1_in : std_logic_vector (width_kernel - 1 downto 0);
    signal kernel_2_in : std_logic_vector (width_kernel - 1 downto 0);

    constant TbPeriod : time := 5 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PB_group
    port map (reset_in       => reset_in,
              en_in       => en_in,
              clk         => clk,
              pixel_0_in  => pixel_0_in,
              pixel_1_in  => pixel_1_in,
              pixel_2_in  => pixel_2_in,
              sum_out_en  => sum_out_en,
              sum_out     => sum_out,
              signed_out  => signed_out,
              kernel_0_in => kernel_0_in,
              kernel_1_in => kernel_1_in,
              kernel_2_in => kernel_2_in);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        en_in <= '0';
        pixel_0_in <= (others => '0');
        pixel_1_in <= (others => '0');
        pixel_2_in <= (others => '0');
        sum_out_en <= '0';
        kernel_0_in <= (others => '0');
        kernel_1_in <= (others => '0');
        kernel_2_in <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_in is really your reset signal
         reset_in <= '1';
         wait for 5 * TbPeriod;
         reset_in <= '0';
         wait for 5 * TbPeriod;

        en_in <= '1';

        pixel_0_in <=   "00000001" ;
        pixel_1_in <=  "00000010" ;
        pixel_2_in <=  "00000001" ;
        kernel_0_in <= "0000000000000001";
        kernel_1_in <= "0000000000000001";
        kernel_2_in <= "0000000000000001";

        wait for 5 * TbPeriod;

        en_in <= '0';

        wait for 3 * TbPeriod;

        sum_out_en <= '1'; 
        wait for 1 * TbPeriod;
        sum_out_en <= '0'; 
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PB_group of tb_PB_group is
    for tb
    end for;
end cfg_tb_PB_group;