-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 7.3.2022 15:26:33 UTC

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_memory_control is
    generic (
        WIDTH_kernel_data : natural := 16;
        WIDTH_kernel_addr : natural := 8;
        reg_nuber : natural := 81;
        num_of_pixels : integer := 8;
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        BRAM_size : integer := 22579;
        WIDTH_num_of_pixels_in_bram : integer := 3;
        DEPTH : integer := 3;
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_bram_adr : integer := 15
    );
end tb_memory_control;

architecture tb of tb_memory_control is

    component memory_control
        port (clk                   : in std_logic;
              reset_in              : in std_logic;
              shift_in              : in std_logic;
              reset_in                : in std_logic;
              write_en              : in std_logic;
              write_0_en_in         : in std_logic;
              w_data_0_in           : in std_logic_vector (width_data - 1 downto 0);
              w_adr_0_in            : in std_logic_vector (width_bram_adr - width_num_of_pixels_in_bram - 1 downto 0);
              bram_adr_in           : in std_logic_vector (width_bram_adr- 1 downto 0);
              bram_data_out         : out std_logic_vector (width_pixel - 1 downto 0);
              bram_data_in          : in std_logic_vector (width_pixel - 1 downto 0);
              pixel_shift_en        : in std_logic;
              pixel_data_in         : in std_logic_vector (width_pixel - 1 downto 0);
              pixel_0_data_out      : out std_logic_vector (width_pixel - 1 downto 0);
              pixel_1_data_out      : out std_logic_vector (width_pixel - 1 downto 0);
              pixel_2_data_out      : out std_logic_vector (width_pixel - 1 downto 0);
              read_pixel_data_en_in : in std_logic;
              r_data_0_out          : out std_logic_vector (width_data - 1 downto 0);
              r_0_kernel_data_out   : out std_logic_vector (width_kernel_data - 1 downto 0);
              r_0_kernel_addr_in    : in std_logic_vector (width_kernel_addr - 1 downto 0);
              r_1_kernel_data_out   : out std_logic_vector (width_kernel_data - 1 downto 0);
              r_1_kernel_addr_in    : in std_logic_vector (width_kernel_addr - 1 downto 0);
              r_2_kernel_data_out   : out std_logic_vector (width_kernel_data - 1 downto 0);
              r_2_kernel_addr_in    : in std_logic_vector (width_kernel_addr - 1 downto 0);
              w_0_kernel_data_in    : in std_logic_vector (width_kernel_data - 1 downto 0);
              w_0_kernel_addr_in    : in std_logic_vector (width_kernel_addr - 1 downto 0);
              write_0_kernel_data   : in std_logic);
    end component;

    signal clk                   : std_logic;
    signal reset_in              : std_logic;
    signal shift_in              : std_logic;
    signal reset_in                : std_logic;
    signal write_en              : std_logic;
    signal write_0_en_in         : std_logic;
    signal w_data_0_in           : std_logic_vector (width_data - 1 downto 0);
    signal w_adr_0_in            : std_logic_vector (width_bram_adr - width_num_of_pixels_in_bram - 1 downto 0);
    signal bram_adr_in           : std_logic_vector (width_bram_adr- 1 downto 0);
    signal bram_data_out         : std_logic_vector (width_pixel - 1 downto 0);
    signal bram_data_in          : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_shift_en        : std_logic;
    signal pixel_data_in         : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_0_data_out      : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_1_data_out      : std_logic_vector (width_pixel - 1 downto 0);
    signal pixel_2_data_out      : std_logic_vector (width_pixel - 1 downto 0);
    signal read_pixel_data_en_in : std_logic;
    signal r_data_0_out          : std_logic_vector (width_data - 1 downto 0);
    signal r_0_kernel_data_out   : std_logic_vector (width_kernel_data - 1 downto 0);
    signal r_0_kernel_addr_in    : std_logic_vector (width_kernel_addr - 1 downto 0);
    signal r_1_kernel_data_out   : std_logic_vector (width_kernel_data - 1 downto 0);
    signal r_1_kernel_addr_in    : std_logic_vector (width_kernel_addr - 1 downto 0);
    signal r_2_kernel_data_out   : std_logic_vector (width_kernel_data - 1 downto 0);
    signal r_2_kernel_addr_in    : std_logic_vector (width_kernel_addr - 1 downto 0);
    signal w_0_kernel_data_in    : std_logic_vector (width_kernel_data - 1 downto 0);
    signal w_0_kernel_addr_in    : std_logic_vector (width_kernel_addr - 1 downto 0);
    signal write_0_kernel_data   : std_logic;

    constant TbPeriod : time := 5 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : memory_control
    port map (clk                   => clk,
              reset_in              => reset_in,
              shift_in              => shift_in,
              reset_in                => reset_in,
              write_en              => write_en,
              write_0_en_in         => write_0_en_in,
              w_data_0_in           => w_data_0_in,
              w_adr_0_in            => w_adr_0_in,
              bram_adr_in           => bram_adr_in,
              bram_data_out         => bram_data_out,
              bram_data_in          => bram_data_in,
              pixel_shift_en        => pixel_shift_en,
              pixel_data_in         => pixel_data_in,
              pixel_0_data_out      => pixel_0_data_out,
              pixel_1_data_out      => pixel_1_data_out,
              pixel_2_data_out      => pixel_2_data_out,
              read_pixel_data_en_in => read_pixel_data_en_in,
              r_data_0_out          => r_data_0_out,
              r_0_kernel_data_out   => r_0_kernel_data_out,
              r_0_kernel_addr_in    => r_0_kernel_addr_in,
              r_1_kernel_data_out   => r_1_kernel_data_out,
              r_1_kernel_addr_in    => r_1_kernel_addr_in,
              r_2_kernel_data_out   => r_2_kernel_data_out,
              r_2_kernel_addr_in    => r_2_kernel_addr_in,
              w_0_kernel_data_in    => w_0_kernel_data_in,
              w_0_kernel_addr_in    => w_0_kernel_addr_in,
              write_0_kernel_data   => write_0_kernel_data);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        shift_in <= '0';
        reset_in <= '0';
        write_en <= '0';
        write_0_en_in <= '0';
        w_data_0_in <= (others => '0');
        w_adr_0_in <= (others => '0');
        bram_adr_in <= (others => '0');
        bram_data_in <= (others => '0');
        pixel_shift_en <= '0';
        pixel_data_in <= (others => '0');
        read_pixel_data_en_in <= '0';
        r_0_kernel_addr_in <= (others => '0');
        r_1_kernel_addr_in <= (others => '0');
        r_2_kernel_addr_in <= (others => '0');
        w_0_kernel_data_in <= (others => '0');
        w_0_kernel_addr_in <= (others => '0');
        write_0_kernel_data <= '0';

        -- Reset generation
        -- EDIT: Check that reset_in is really your reset signal
        reset_in <= '1';
        wait for 1 * TbPeriod;
        reset_in <= '0';
        wait for 1 * TbPeriod;

        w_0_kernel_data_in <= std_logic_vector(to_unsigned(100, w_0_kernel_data_in'length));
        w_0_kernel_addr_in <=  std_logic_vector(to_unsigned(1, w_0_kernel_addr_in'length));
        write_0_kernel_data <= '1';

        write_0_en_in <= '1';
        bram_adr_in <= (others => '0');
        bram_data_in <= std_logic_vector(to_unsigned(10, bram_data_in'length));

        wait for 3 * TbPeriod;
        w_0_kernel_data_in <= (others => '0');
        write_0_kernel_data <= '0';
        bram_data_in <= (others => '0');
        write_0_en_in <= '0';
        wait for 3 * TbPeriod;

        r_0_kernel_addr_in <= std_logic_vector(to_unsigned(1, r_0_kernel_addr_in'length));
        pixel_shift_en <= '1';
        wait for 3 * TbPeriod;
        r_0_kernel_addr_in <= (others => '0');
        pixel_shift_en <= '0';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_memory_control of tb_memory_control is
    for tb
    end for;
end cfg_tb_memory_control;