----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 01:53:36 PM
-- Design Name: 
-- Module Name: MCU - Behavioral
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

entity convolution_ip is
    generic (
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        WIDTH_bram_adr : integer := 14;
        BRAM_size : integer := 22579;
        num_of_pixels : integer := 8;
        reg_nuber : natural := 81;
        WIDTH_conv_out_data : natural := 2;
        DEPTH : natural := 3;
        WIDTH_kernel_addr : natural := 8;
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data : natural := 16; -- Number of bits needed to represent kernel value
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed");
    port (
        -- ip interfaces
        clk : in std_logic;
        reset_in : in std_logic;
        start_in : in std_logic;
        ready_out : out std_logic;

        done_out : out std_logic;

        bram_read_data_en_out : out std_logic;
        bram_pixel_data_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        bram_pixel_adr_out : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        -- bram interface for conv out data... write en is missing
        bram_conv_res_data_out : out std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
        bram_conv_res_adr_out : out std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
        bram_conv_res_write_en_out : out std_logic

    );
end convolution_ip;

architecture Behavioral of convolution_ip is
    -- component declaration

    component conv_FSM
        generic (
            WIDTH_pixel : integer := 8;
            WIDTH_kernel : integer := 16;
            KERNEL_SIZE : integer := 9;
            WIDTH_kernel_size : integer := 4;
            DEFAULT_IMG_SIZE : integer := 100;
            WIDTH_img_size : integer := 7;
            WIDTH_bram_in_out_adr : integer := 14;
            WIDTH_kernel_adr : integer := 6;
            WIDTH_conv_out : integer := 2;

            SUM_WIDTH : integer := 32); --27 actually);
        port (
            clk_i : in std_logic;
            reset_in : in std_logic;
            start_in : in std_logic;
            reset_out : out std_logic;
            shift_addreses_out : out std_logic;
            i_o : out std_logic_vector (WIDTH_img_size - 1 downto 0);
            j_o : out std_logic_vector (WIDTH_img_size - 1 downto 0);
            k_o : out std_logic_vector (WIDTH_kernel_size - 1 downto 0);
            l_o : out std_logic_vector (WIDTH_kernel_size - 1 downto 0);
            calculate_p_k_adr_o : out std_logic;
            calculate_conv_adr_o : out std_logic;
            mac_en_o : out std_logic;
            sum_en_o : out std_logic;
            reset_PB_o : out std_logic;
            ready_o : out std_logic;
            done_o : out std_logic);
    end component;

    component PB_group
        generic (
            WIDTH_pixel : natural := 8;
            WIDTH_kernel : natural := 16;
            WIDTH_sum : natural := 32;
            WIDTH_conv : natural := 2;
            SIGNED_UNSIGNED : string := "signed"
        );
        port (
            reset_in : in std_logic;
            en_in : in std_logic;
            clk : in std_logic;
            reset_sum_in : in std_logic;
            bram_write_enable_out : out std_logic;
            pixel_0_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_1_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_2_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
            sum_out_en : in std_logic;
            sum_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
            signed_out : out std_logic_vector(WIDTH_conv - 1 downto 0);
            kernel_0_in : in std_logic_vector (WIDTH_kernel - 1 downto 0);
            kernel_1_in : in std_logic_vector (WIDTH_kernel - 1 downto 0);
            kernel_2_in : in std_logic_vector (WIDTH_kernel - 1 downto 0));
    end component;

    component adress_controler
        generic (
            WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
            DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
            WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
            KERNEL_SIZE : natural := 9; -- widht/height of kernel
            WIDTH_kernel_size : natural := 4; --Number of bits needed to reporesent kernel size
            WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
            WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
            WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
            WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
            WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
            SIGNED_UNSIGNED : string := "signed"
        );
        port (
            clk : in std_logic;
            reset_in : in std_logic;
            calc_adr_i : in std_logic;
            calc_conv_adr_i : in std_logic;
            shift_en_in : in std_logic;
            i_i : in std_logic_vector (WIDTH_img_size - 1 downto 0);
            j_i : in std_logic_vector (WIDTH_img_size - 1 downto 0);
            k_i : in std_logic_vector (WIDTH_kernel_size - 1 downto 0);
            l_i : in std_logic_vector (WIDTH_kernel_size - 1 downto 0);
            conv_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
            kernel_0_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
            kernel_1_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
            kernel_2_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
            bram_shifted_out : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
            bram_read_en_out : out std_logic);
    end component;

    component memory_control
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
        port (
            clk : in std_logic;
            reset_in : in std_logic;
            -- shift_in : in std_logic;
            -- write_en : in std_logic;
            write_0_en_in : in std_logic;
            w_data_0_in : in std_logic_vector (WIDTH_data - 1 downto 0);
            w_adr_0_in : in std_logic_vector (WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
            bram_adr_in : in std_logic_vector (WIDTH_bram_adr - 1 downto 0);
            bram_data_out : out std_logic_vector (WIDTH_pixel - 1 downto 0);
            bram_data_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_shift_en : in std_logic;
            pixle_shift_en_out : out std_logic;
            pixel_data_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_0_data_out : out std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_1_data_out : out std_logic_vector (WIDTH_pixel - 1 downto 0);
            pixel_2_data_out : out std_logic_vector (WIDTH_pixel - 1 downto 0);
            -- read_pixel_data_en_in : in std_logic;
            -- r_data_0_out : out std_logic_vector (WIDTH_data - 1 downto 0);
            r_0_kernel_data_out : out std_logic_vector (WIDTH_kernel_data - 1 downto 0);
            r_0_kernel_addr_in : in std_logic_vector (WIDTH_kernel_addr - 1 downto 0);
            r_1_kernel_data_out : out std_logic_vector (WIDTH_kernel_data - 1 downto 0);
            r_1_kernel_addr_in : in std_logic_vector (WIDTH_kernel_addr - 1 downto 0);
            r_2_kernel_data_out : out std_logic_vector (WIDTH_kernel_data - 1 downto 0);
            r_2_kernel_addr_in : in std_logic_vector (WIDTH_kernel_addr - 1 downto 0);
            w_0_kernel_data_in : in std_logic_vector (WIDTH_kernel_data - 1 downto 0);
            w_0_kernel_addr_in : in std_logic_vector (WIDTH_kernel_addr - 1 downto 0);
            write_0_kernel_data : in std_logic);
    end component;

    --signal declaration
    signal clk_s, reset_in_s, calc_adr_i_s, calc_conv_adr_i_s, shift_en_in_s : std_logic;
    signal i_i_s : std_logic_vector (WIDTH_img_size - 1 downto 0);
    signal j_i_s : std_logic_vector (WIDTH_img_size - 1 downto 0);
    signal k_i_s : std_logic_vector (WIDTH_kernel_size - 1 downto 0);
    signal l_i_s : std_logic_vector (WIDTH_kernel_size - 1 downto 0);
    -- out of mem control into MAC
    signal r_0_kernel_data_out_s : std_logic_vector(WIDTH_kernel_data - 1 downto 0);
    signal r_1_kernel_data_out_s : std_logic_vector(WIDTH_kernel_data - 1 downto 0);
    signal r_2_kernel_data_out_s : std_logic_vector(WIDTH_kernel_data - 1 downto 0);
    -- out of mem control into MAC
    signal pixel_0_data_out_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal pixel_1_data_out_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal pixel_2_data_out_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal conv_adr_o_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
    signal kernel_0_adr_o_s : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal kernel_1_adr_o_s : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal kernel_2_adr_o_s : std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
    signal bram_shifted_out_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
    signal bram_read_en_out_s : std_logic;
    --signals for transfering data from IP integrator bram to MAC
    signal bram_read_data_en_out_s : std_logic;
    signal bram_pixel_data_in_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal bram_pixel_adr_out_s : std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
    signal pixle_shift_en_out_s : std_logic;
    --used for testing bram... to be deleted afterwards, ip integrator should be used for bram.
    signal write_0_en_in : std_logic;
    signal w_data_0_in : std_logic_vector(WIDTH_data - 1 downto 0);
    signal w_adr_0_in : std_logic_vector(WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
    --read data for bram
    signal bram_adr_in : std_logic_vector (WIDTH_bram_adr - 1 downto 0);
    signal bram_data_out : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal bram_data_in : std_logic_vector(WIDTH_pixel - 1 downto 0);
    -- for testing reg bank for kernel data
    signal w_0_kernel_data_in : std_logic_vector (WIDTH_kernel_data - 1 downto 0);
    signal w_0_kernel_addr_in : std_logic_vector (WIDTH_kernel_addr - 1 downto 0);
    signal write_0_kernel_data : std_logic;

    --PB group signals 

    signal en_in_s, sum_out_en_s : std_logic;
    signal signed_out_s : std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
    signal sum_out_s : std_logic_vector (WIDTH_sum - 1 downto 0);

    --FSM signals
    signal calculate_p_k_adr_s : std_logic;
    signal calculate_conv_adr_s : std_logic;
    signal mac_en_s  : std_logic;
    signal sum_en_s : std_logic;
    signal reset_PB_s : std_logic;
    signal done_s : std_logic;
    signal ready_s : std_logic;
    signal conv_en_out_s : std_logic;
    signal reset_out_s : std_logic;
begin

    clk_s <= clk;
    reset_in_s <= reset_in;
    bram_conv_res_data_out <= signed_out_s;
    done_out <= done_s;
    bram_pixel_data_in_s <= bram_pixel_data_in;
    bram_pixel_adr_out <= bram_pixel_adr_out_s;
    bram_read_data_en_out <= pixle_shift_en_out_s;
    bram_conv_res_adr_out <= conv_adr_o_s;
    ready_out <= ready_s;
    


    adr_control : adress_controler
    generic map(
        WIDTH_num_of_pixels_in_bram => WIDTH_num_of_pixels_in_bram,
        DEFAULT_IMG_SIZE => DEFAULT_IMG_SIZE,
        WIDTH_img_size => WIDTH_img_size,
        KERNEL_SIZE => KERNEL_SIZE,
        WIDTH_kernel_size => WIDTH_kernel_size,
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        WIDTH_sum => WIDTH_sum,
        WIDTH_bram_in_out_adr => WIDTH_bram_in_out_adr,
        WIDTH_kernel_adr => WIDTH_kernel_adr,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map(
        clk => clk_s,
        reset_in => reset_out_s,
        calc_adr_i => calc_adr_i_s,
        calc_conv_adr_i => calc_conv_adr_i_s,
        shift_en_in => shift_en_in_s,
        i_i => i_i_s,
        j_i => j_i_s,
        k_i => k_i_s,
        l_i => l_i_s,
        conv_adr_o => conv_adr_o_s,
        kernel_0_adr_o => kernel_0_adr_o_s,
        kernel_1_adr_o => kernel_1_adr_o_s,
        kernel_2_adr_o => kernel_2_adr_o_s,
        bram_shifted_out => bram_pixel_adr_out_s,
        bram_read_en_out => bram_read_data_en_out_s

    );

    memory_controler : memory_control
    generic map(
        WIDTH_kernel_data => WIDTH_kernel_data,
        WIDTH_kernel_addr => WIDTH_kernel_addr,
        reg_nuber => reg_nuber,
        num_of_pixels => num_of_pixels,
        WIDTH_data => WIDTH_data,
        WIDTH_adr => WIDTH_adr,
        BRAM_size => BRAM_size,
        WIDTH_num_of_pixels_in_bram => WIDTH_num_of_pixels_in_bram,
        DEPTH => DEPTH,
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_bram_adr => WIDTH_bram_adr
    )
    port map(
        clk => clk_s, --
        reset_in => reset_out_s, --
        write_0_en_in => write_0_en_in,
        w_data_0_in => w_data_0_in,
        w_adr_0_in => w_adr_0_in,
        bram_adr_in => bram_shifted_out_s, --
        bram_data_out => bram_data_out,
        bram_data_in => bram_data_in,
        pixel_shift_en => bram_read_data_en_out_s, --shift_en_in_s
        pixle_shift_en_out => pixle_shift_en_out_s, -- bram out 
        pixel_data_in => bram_pixel_data_in_s, --
        pixel_0_data_out => pixel_0_data_out_s, --
        pixel_1_data_out => pixel_1_data_out_s, --
        pixel_2_data_out => pixel_2_data_out_s, --
        r_0_kernel_data_out => r_0_kernel_data_out_s, --
        r_0_kernel_addr_in => kernel_0_adr_o_s, --
        r_1_kernel_data_out => r_1_kernel_data_out_s, --
        r_1_kernel_addr_in => kernel_1_adr_o_s, --
        r_2_kernel_data_out => r_2_kernel_data_out_s, --
        r_2_kernel_addr_in => kernel_2_adr_o_s, --
        w_0_kernel_data_in => w_0_kernel_data_in, --
        w_0_kernel_addr_in => w_0_kernel_addr_in, --
        write_0_kernel_data => write_0_kernel_data);--

    proccesing_block : PB_group
    generic map(
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        WIDTH_sum => WIDTH_sum,
        WIDTH_conv => WIDTH_conv_out_data,
        SIGNED_UNSIGNED => SIGNED_UNSIGNED
    )
    port map(
        reset_in => reset_out_s,
        en_in => mac_en_s,
        clk => clk_s,
        bram_write_enable_out => bram_conv_res_write_en_out,
        reset_sum_in => reset_PB_s,
        pixel_0_in => pixel_0_data_out_s,
        pixel_1_in => pixel_1_data_out_s,
        pixel_2_in => pixel_2_data_out_s,
        sum_out_en => sum_en_s,
        sum_out => sum_out_s,
        signed_out => signed_out_s,
        kernel_0_in => r_0_kernel_data_out_s,
        kernel_1_in => r_1_kernel_data_out_s,
        kernel_2_in => r_2_kernel_data_out_s);

    conv_ip_FSM : conv_FSM
    generic map(
        WIDTH_pixel => WIDTH_pixel,
        WIDTH_kernel => WIDTH_kernel,
        KERNEL_SIZE => KERNEL_SIZE,
        WIDTH_kernel_size => WIDTH_kernel_size,
        DEFAULT_IMG_SIZE => DEFAULT_IMG_SIZE,
        WIDTH_img_size => WIDTH_img_size,
        WIDTH_bram_in_out_adr => WIDTH_bram_in_out_adr,
        WIDTH_kernel_adr => WIDTH_kernel_adr,
        WIDTH_conv_out => WIDTH_conv_out_data,
        SUM_WIDTH => WIDTH_sum --27 actually);
    )
    port map (clk_i                => clk_s,
              reset_in              => reset_in_s,
              start_in              => start_in,
              reset_out            => reset_out_s,
              shift_addreses_out   => shift_en_in_s,
              i_o                  => i_i_s,
              j_o                  => j_i_s,
              k_o                  => k_i_s,
              l_o                  => l_i_s,
              calculate_p_k_adr_o  => calc_adr_i_s,
              calculate_conv_adr_o => calc_conv_adr_i_s,
              mac_en_o             => mac_en_s,
              sum_en_o             => sum_en_s,
              reset_PB_o           => reset_PB_s,
              ready_o              => ready_s,
              done_o               => done_s);

end Behavioral;