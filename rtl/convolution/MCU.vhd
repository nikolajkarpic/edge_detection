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

entity MCU is
    generic (
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- width/height of the image
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed");
    port (
        clk : in std_logic;
        reset_in : in std_logic;

        -- adress IO
        calc_adr_i : in std_logic;
        calc_conv_adr_i : in std_logic;
        en_in : in std_logic;

        --Data from FSM to calculate adresses.
        i_i : in std_logic_vector (width_img_size - 1 downto 0);
        j_i : in std_logic_vector (width_img_size - 1 downto 0);
        k_i : in std_logic_vector (width_kernel_size - 1 downto 0);
        l_i : in std_logic_vector (width_kernel_size - 1 downto 0);

        -- kernel data out .... conects to MAC
        r_0_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_1_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_2_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        -- pixel data out .... conects to MAC
        pixel_0_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_1_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_2_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        -- address where to save mac data
        conv_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0)
    );
end MCU;

architecture Behavioral of MCU is
    -- component declaration
    component adress_controler
        port (
            clk : in std_logic;
            reset_in : in std_logic;
            calc_adr_i : in std_logic;
            calc_conv_adr_i : in std_logic;
            en_in : in std_logic;
            i_i : in std_logic_vector (width_img_size - 1 downto 0);
            j_i : in std_logic_vector (width_img_size - 1 downto 0);
            k_i : in std_logic_vector (width_kernel_size - 1 downto 0);
            l_i : in std_logic_vector (width_kernel_size - 1 downto 0);
            conv_adr_o : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
            kernel_0_adr_o : out std_logic_vector (width_kernel_adr - 1 downto 0);
            kernel_1_adr_o : out std_logic_vector (width_kernel_adr - 1 downto 0);
            kernel_2_adr_o : out std_logic_vector (width_kernel_adr - 1 downto 0);
            bram_shifted_out : out std_logic_vector (width_bram_in_out_adr - 1 downto 0);
            bram_read_en_out : out std_logic);
    end component;

    component memory_control
        port (
            clk : in std_logic;
            reset_in : in std_logic;
            shift_in : in std_logic;
            reset_in : in std_logic;
            write_en : in std_logic;
            write_0_en_in : in std_logic;
            w_data_0_in : in std_logic_vector (width_data - 1 downto 0);
            w_adr_0_in : in std_logic_vector (width_bram_adr - width_num_of_pixels_in_bram - 1 downto 0);
            bram_adr_in : in std_logic_vector (width_bram_adr - 1 downto 0);
            bram_data_out : out std_logic_vector (width_pixel - 1 downto 0);
            bram_data_in : in std_logic_vector (width_pixel - 1 downto 0);
            pixel_shift_en : in std_logic;
            pixel_data_in : in std_logic_vector (width_pixel - 1 downto 0);
            pixel_0_data_out : out std_logic_vector (width_pixel - 1 downto 0);
            pixel_1_data_out : out std_logic_vector (width_pixel - 1 downto 0);
            pixel_2_data_out : out std_logic_vector (width_pixel - 1 downto 0);
            read_pixel_data_en_in : in std_logic;
            r_data_0_out : out std_logic_vector (width_data - 1 downto 0);
            r_0_kernel_data_out : out std_logic_vector (width_kernel_data - 1 downto 0);
            r_0_kernel_addr_in : in std_logic_vector (width_kernel_addr - 1 downto 0);
            r_1_kernel_data_out : out std_logic_vector (width_kernel_data - 1 downto 0);
            r_1_kernel_addr_in : in std_logic_vector (width_kernel_addr - 1 downto 0);
            r_2_kernel_data_out : out std_logic_vector (width_kernel_data - 1 downto 0);
            r_2_kernel_addr_in : in std_logic_vector (width_kernel_addr - 1 downto 0);
            w_0_kernel_data_in : in std_logic_vector (width_kernel_data - 1 downto 0);
            w_0_kernel_addr_in : in std_logic_vector (width_kernel_addr - 1 downto 0);
            write_0_kernel_data : in std_logic);
    end component;

    --signal declaration
    
begin
end Behavioral;