----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/05/2022 12:13:59 AM
-- Design Name: 
-- Module Name: conv_FSM_tb - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;

entity tb_conv_FSM is
    generic(WIDTH_pixel : integer := 8;
    WIDTH_kernel : integer := 16;
    KERNEL_SIZE : integer := 9;
    WIDTH_kernel_size : integer := 4;
    DEFAULT_IMG_SIZE : integer := 100;
    WIDTH_img_size : integer := 7;
    WIDTH_bram_in_out_adr : integer := 14;
    WIDTH_kernel_adr : integer := 6;
    WIDTH_conv_out : integer := 2;

    SUM_WIDTH : integer := 32); --27 actually);
end tb_conv_FSM;

architecture tb of tb_conv_FSM is

    component conv_FSM
        port (clk_i                : in std_logic;
              reset_i              : in std_logic;
              start_i              : in std_logic;
            --   pixel_0_val_i        : in std_logic_vector (width_pixel - 1 downto 0);
            --   pixel_1_val_i        : in std_logic_vector (width_pixel - 1 downto 0);
            --   pixel_2_val_i        : in std_logic_vector (width_pixel - 1 downto 0);
            --   kernel_0_val_i       : in std_logic_vector (width_kernel - 1 downto 0);
            --   kernel_1_val_i       : in std_logic_vector (width_kernel - 1 downto 0);
            --   kernel_2_val_i       : in std_logic_vector (width_kernel - 1 downto 0);
            --   pixel_0_adr_o        : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
            --   pixel_1_adr_o        : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
            --   pixel_2_adr_o        : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
            --   kernel_0_adr_o       : out std_logic_vector (width_kernel_adr - 1 downto 0);
            --   kernel_1_adr_o       : out std_logic_vector (width_kernel_adr - 1 downto 0);
            --   kernel_2_adr_o       : out std_logic_vector (width_kernel_adr - 1 downto 0);
            inc_l_out : out std_logic;
              i_o                  : out std_logic_vector (width_img_size - 1 downto 0);
              j_o                  : out std_logic_vector (width_img_size - 1 downto 0);
              k_o                  : out std_logic_vector (width_kernel_size - 1 downto 0);
              l_o                  : out std_logic_vector (width_kernel_size - 1 downto 0);
              calculate_p_k_adr_o  : out std_logic;
              calculate_conv_adr_o : out std_logic;
              mac_en_o             : out std_logic;
              sum_en_o             : out std_logic;
              reset_PB_o           : out std_logic;
              conv_en_out          : out std_logic;
              conv_o               : out std_logic_vector (1 downto 0);
              conv_out_adr_o       : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
              ready_o              : out std_logic;
              done_o               : out std_logic);
    end component;

    signal clk_i                : std_logic;
    signal reset_i              : std_logic;
    signal start_i              : std_logic;
    -- signal pixel_0_val_i        : std_logic_vector (width_pixel - 1 downto 0);
    -- signal pixel_1_val_i        : std_logic_vector (width_pixel - 1 downto 0);
    -- signal pixel_2_val_i        : std_logic_vector (width_pixel - 1 downto 0);
    -- signal kernel_0_val_i       : std_logic_vector (width_kernel - 1 downto 0);
    -- signal kernel_1_val_i       : std_logic_vector (width_kernel - 1 downto 0);
    -- signal kernel_2_val_i       : std_logic_vector (width_kernel - 1 downto 0);
    -- signal pixel_0_adr_o        : std_logic_vector (width_bram_in_out_adr - 1 downto 0);
    -- signal pixel_1_adr_o        : std_logic_vector (width_bram_in_out_adr - 1 downto 0);
    -- signal pixel_2_adr_o        : std_logic_vector (width_bram_in_out_adr - 1 downto 0);
    -- signal kernel_0_adr_o       : std_logic_vector (width_kernel_adr - 1 downto 0);
    -- signal kernel_1_adr_o       : std_logic_vector (width_kernel_adr - 1 downto 0);
    -- signal kernel_2_adr_o       : std_logic_vector (width_kernel_adr - 1 downto 0);
    signal inc_l_out : std_logic;
    signal i_o                  : std_logic_vector (width_img_size - 1 downto 0);
    signal j_o                  : std_logic_vector (width_img_size - 1 downto 0);
    signal k_o                  : std_logic_vector (width_kernel_size - 1 downto 0);
    signal l_o                  : std_logic_vector (width_kernel_size - 1 downto 0);
    signal calculate_p_k_adr_o  : std_logic;
    signal calculate_conv_adr_o : std_logic;
    signal mac_en_o             : std_logic;
    signal sum_en_o             : std_logic;
    signal reset_PB_o           : std_logic;
    signal conv_en_out          : std_logic;
    signal conv_o               : std_logic_vector (1 downto 0);
    signal conv_out_adr_o       : std_logic_vector (width_bram_in_out_adr - 1 downto 0);
    signal ready_o              : std_logic;
    signal done_o               : std_logic;

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : conv_FSM
    port map (clk_i                => clk_i,
              reset_i              => reset_i,
              start_i              => start_i,
            --   pixel_0_val_i        => pixel_0_val_i,
            --   pixel_1_val_i        => pixel_1_val_i,
            --   pixel_2_val_i        => pixel_2_val_i,
            --   kernel_0_val_i       => kernel_0_val_i,
            --   kernel_1_val_i       => kernel_1_val_i,
            --   kernel_2_val_i       => kernel_2_val_i,
            --   pixel_0_adr_o        => pixel_0_adr_o,
            --   pixel_1_adr_o        => pixel_1_adr_o,
            --   pixel_2_adr_o        => pixel_2_adr_o,
            --   kernel_0_adr_o       => kernel_0_adr_o,
            --   kernel_1_adr_o       => kernel_1_adr_o,
            --   kernel_2_adr_o       => kernel_2_adr_o,
            inc_l_out => inc_l_out ,
              i_o                  => i_o,
              j_o                  => j_o,
              k_o                  => k_o,
              l_o                  => l_o,
              calculate_p_k_adr_o  => calculate_p_k_adr_o,
              calculate_conv_adr_o => calculate_conv_adr_o,
              mac_en_o             => mac_en_o,
              sum_en_o             => sum_en_o,
              reset_PB_o           => reset_PB_o,
              conv_en_out          => conv_en_out,
              conv_o               => conv_o,
              conv_out_adr_o       => conv_out_adr_o,
              ready_o              => ready_o,
              done_o               => done_o);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk_i is really your main clock signal
    clk_i <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start_i <= '0';
        -- pixel_0_val_i <= (others => '0');
        -- pixel_1_val_i <= (others => '0');
        -- pixel_2_val_i <= (others => '0');
        -- kernel_0_val_i <= (others => '0');
        -- kernel_1_val_i <= (others => '0');
        -- kernel_2_val_i <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_i is really your reset signal
        reset_i <= '1';
        wait for 100 ns;
        reset_i <= '0';
        wait for 100 ns;

        start_i <= '1';
        wait for 10 * TbPeriod;
        start_i <= '0';
        wait for 1 * TbPeriod;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_conv_FSM of tb_conv_FSM is
    for tb
    end for;
end cfg_tb_conv_FSM;