-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 4.3.2022 12:46:38 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_adress_controler is
    generic (
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed"
    );
end tb_adress_controler;

architecture tb of tb_adress_controler is

    component adress_controler
        port (clk              : in std_logic;
              reset_in            : in std_logic;
              calc_adr_i       : in std_logic;
              calc_conv_adr_i  : in std_logic;
              en_in            : in std_logic;
              i_i              : in std_logic_vector (WIDTH_img_size - 1 downto 0);
              j_i              : in std_logic_vector (WIDTH_img_size - 1 downto 0);
              k_i              : in std_logic_vector (WIDTH_kernel_size - 1 downto 0);
              l_i              : in std_logic_vector (WIDTH_kernel_size - 1 downto 0);
              conv_adr_o       : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
              kernel_0_adr_o   : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
              kernel_1_adr_o   : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
              kernel_2_adr_o   : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
              bram_shifted_out : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
              bram_read_en_out : out std_logic);
    end component;

    signal clk              : std_logic;
    signal reset_in            : std_logic;
    signal calc_adr_i       : std_logic;
    signal calc_conv_adr_i  : std_logic;
    signal en_in            : std_logic;
    signal i_i              : std_logic_vector (WIDTH_img_size - 1 downto 0);
    signal j_i              : std_logic_vector (WIDTH_img_size - 1 downto 0);
    signal k_i              : std_logic_vector (WIDTH_kernel_size - 1 downto 0);
    signal l_i              : std_logic_vector (WIDTH_kernel_size - 1 downto 0);
    signal conv_adr_o       : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
    signal kernel_0_adr_o   : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal kernel_1_adr_o   : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal kernel_2_adr_o   : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal bram_shifted_out : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
    signal bram_read_en_out : std_logic;

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : adress_controler
    port map (clk              => clk,
              reset_in            => reset_in,
              calc_adr_i       => calc_adr_i,
              calc_conv_adr_i  => calc_conv_adr_i,
              en_in            => en_in,
              i_i              => i_i,
              j_i              => j_i,
              k_i              => k_i,
              l_i              => l_i,
              conv_adr_o       => conv_adr_o,
              kernel_0_adr_o   => kernel_0_adr_o,
              kernel_1_adr_o   => kernel_1_adr_o,
              kernel_2_adr_o   => kernel_2_adr_o,
              bram_shifted_out => bram_shifted_out,
              bram_read_en_out => bram_read_en_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        calc_adr_i <= '0';
        calc_conv_adr_i <= '0';
        en_in <= '0';
        i_i <= (others => '0');
        j_i <= (others => '0');
        k_i <= (others => '0');
        l_i <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_in is really your reset signal
        reset_in <= '1';
        wait for 300 ns;
        reset_in <= '0';
        wait for 100 ns;

        reset_in <= '0';
        calc_adr_i <= '0';
        calc_conv_adr_i <= '0';
        en_in <= '0';
        i_i <= (others => '0');
        j_i <= (others => '0');
        k_i <= (others => '0');
        l_i <= (others => '0');
        wait for 100 ns;
        calc_adr_i <= '1';
        calc_conv_adr_i <= '1';
        wait for 1 * TbPeriod;
        calc_adr_i <= '0';
        calc_conv_adr_i <= '0';
        en_in <= '1';

        -- i_i <="0000100";

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_adress_controler of tb_adress_controler is
    for tb
    end for;
end cfg_tb_adress_controler;