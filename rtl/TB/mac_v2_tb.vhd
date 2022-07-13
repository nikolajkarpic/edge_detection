-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 1.2.2022 19:42:11 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_mac_v2 is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 24;
        SIGNED_UNSIGNED : string := "signed"
    );
end tb_mac_v2;

architecture tb of tb_mac_v2 is

    component mac_v2
        port ( pixel_0_in, pixel_1_in, pixel_2_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
        kernel_0_in, kernel_1_in, kernel_2_in : in std_logic_vector (WIDTH_kernel - 1 downto 0);
        clk : in std_logic;
        enable_in : in std_logic;
        reset_in : in std_logic;
        sum_final_en : in std_logic;
        sum0_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum1_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum2_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum_out : out std_logic_vector (WIDTH_sum - 1 downto 0));
    end component;

    signal pixel_0_in   : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal pixel_1_in   : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal pixel_2_in   : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal kernel_0_in  : std_logic_vector (WIDTH_kernel - 1 downto 0);
    signal kernel_1_in  : std_logic_vector (WIDTH_kernel - 1 downto 0);
    signal kernel_2_in  : std_logic_vector (WIDTH_kernel - 1 downto 0);
    signal clk          : std_logic;
    signal enable_in    : std_logic;
    signal reset_in     : std_logic;
    signal sum_final_en : std_logic;
    signal sum_out      : std_logic_vector (WIDTH_sum - 1 downto 0);
    signal sum0_out      : std_logic_vector (WIDTH_sum - 1 downto 0);
    signal sum1_out      : std_logic_vector (WIDTH_sum - 1 downto 0);
    signal sum2_out      : std_logic_vector (WIDTH_sum - 1 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : mac_v2
    port map (pixel_0_in   => pixel_0_in,
              pixel_1_in   => pixel_1_in,
              pixel_2_in   => pixel_2_in,
              kernel_0_in  => kernel_0_in,
              kernel_1_in  => kernel_1_in,
              kernel_2_in  => kernel_2_in,
              clk          => clk,
              enable_in    => enable_in,
              reset_in     => reset_in,
              sum_final_en => sum_final_en,
              sum_out      => sum_out,
              sum0_out      => sum0_out,
              sum1_out      => sum1_out,
              sum2_out      => sum2_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        pixel_0_in <= (others => '0');
        pixel_1_in <= (others => '0');
        pixel_2_in <= (others => '0');
        kernel_0_in <= (others => '0');
        kernel_1_in <= (others => '0');
        kernel_2_in <= (others => '0');
        enable_in <= '0';
        sum_final_en <= '0';

        -- Reset generation
        -- EDIT: Check that reset_in is really your reset signal
        reset_in <= '1';
        wait for 100 ns;
        reset_in <= '0';
        wait for 100 ns;

        pixel_0_in <= "00000001";
        pixel_1_in <= (others => '0');
        pixel_2_in <= (others => '0');
        kernel_0_in <= "0000000000000001";
        kernel_1_in <= (others => '0');
        kernel_2_in <= (others => '0');
        enable_in <= '1';

        wait for 10 * TbPeriod;

        enable_in <= '0';
        sum_final_en <= '1';
        wait for 1 * TbPeriod;
        sum_final_en <= '0';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_mac_v2 of tb_mac_v2 is
    for tb
    end for;
end cfg_tb_mac_v2;