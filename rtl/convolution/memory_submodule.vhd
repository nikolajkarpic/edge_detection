----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2022 06:45:36 PM
-- Design Name: 
-- Module Name: memory_submodule - Behavioral
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
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_submodule is
generic (
        SIZE: integer := 160000; --????????
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
    Port (
        clk : in std_logic;
        reset: in std_logic;
        
        
        --axi interface
        reg_data_i : in std_logic;
        start_wr_i : in std_logic;
--        done_wr_i : in std_logic;
--        ready_wr_i : in std_logic;
        
        start_axi_o : out std_logic;
        done_axi_o : out std_logic;
        ready_axi_o : out std_logic;
        
        mem_addr_i : in std_logic_vector(WIDTH_bram_adr-1 + 1 downto 0);
        mem_data_i : in std_logic_vector(31 downto 0);
        mem_wr_i : in std_logic;
        
        pixel_axi_data_o : out std_logic_vector(WIDTH_pixel-1 downto 0);
        sign_axi_data_o : out std_logic_vector(WIDTH_conv_out_data-1 downto 0);
        
        -- interfaces for IP
        start_out : out std_logic;
        ready_in : in std_logic;
        done_in : in std_logic;

        bram_read_data_en_in : in std_logic;
        bram_pixel_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        bram_pixel_adr_in : in std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        -- bram interface for conv out data... write en is missing
        bram_conv_res_data_in : in std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
        bram_conv_res_adr_in : in std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
        bram_conv_res_write_en_in : in std_logic
         );
end memory_submodule;

architecture Behavioral of memory_submodule is
    signal start_s, ready_s, done_s: std_logic;
    signal en_pixel_s, en_sign_s : std_logic;
    
begin


--interfaces for IP
start_out <= start_s;

--registers
start_axi_o<= start_s;
done_axi_o <= done_s;
ready_axi_o <= ready_s;



-- ready register
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ready_s <= '0';
        else
            ready_s <= ready_in;
        end if;
    end if;
end process;

-- start register
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            start_s <= '0';
        elsif start_wr_i = '1' then
            start_s <= reg_data_i;
        end if;
    end if;
end process;

-- done register
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            done_s <= '0';
        else
            done_s <= done_in;
        end if;
    end if;
end process;

-- Address decoder
addr_dec: process (mem_addr_i)
begin
    -- Default assignments
    en_pixel_s <= '0';
    en_sign_s <= '0';
    case mem_addr_i(14) is
        when '0' =>
            en_pixel_s <= '1';
        when '1' =>
            en_sign_s <= '1';
    end case;
end process;


-- Memory for storing the elements of pixels
pixel_memory: entity work.dp_bram(beh)
generic map (
    WIDTH => WIDTH_pixel,
    SIZE => SIZE
)
port map (
    ckla => clk,
    ena => en_pixel_s,
    wea => mem_wr_i,
    addra => mem_addr_i(WIDTH_bram_adr-1 downto 0),
    dia => mem_data_i(WIDTH_pixel-1 downto 0),
    doa => pixel_axi_data_o,
    clkb => clk,
    enb => '1',
    web => bram_read_data_en_in,
    addrb => bram_pixel_adr_in,
    dib => (others => '0'),
    dob => bram_pixel_data_out
);


-- Memory for storing the elements of sign results
sign_memory: entity work.dp_bram(beh)
generic map (
    WIDTH => WIDTH_conv_out_data,
    SIZE => SIZE
)
port map (
    ckla => clk,
    ena => en_sign_s,
    wea => mem_wr_i,
    addra => mem_addr_i(WIDTH_bram_adr-1 downto 0),
    dia => mem_data_i(WIDTH_pixel + WIDTH_conv_out_data-1 downto WIDTH_pixel),
    doa => sign_axi_data_o,
    clkb => clk,
    enb => '1',
    web => bram_conv_res_write_en_in,
    addrb => bram_conv_res_adr_in,
    dib => bram_conv_res_data_in,
    dob => open
);


end Behavioral;
