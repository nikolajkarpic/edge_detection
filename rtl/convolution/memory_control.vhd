----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2022 03:25:08 PM
-- Design Name: 
-- Module Name: memory_control - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_control is
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
        WIDTH_bram_adr : integer := 14
    );
    port (
        -- clocking
        clk : in std_logic;
        reset_in : in std_logic;

        --piso

        -- shift_in : in std_logic;
        -- write_en : in std_logic;

        
        --TESTING BRAM ACCESS AND WRITING... IP INTEGRATOR WILL BE USED TO IMPLEMENT BRAM.
        --write data to BRAM
        write_0_en_in : in std_logic;
        w_data_0_in : in std_logic_vector(WIDTH_data - 1 downto 0);
        w_adr_0_in : in std_logic_vector(WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
        --read data for bram
        bram_adr_in : in std_logic_vector (WIDTH_bram_adr - 1 downto 0);
        bram_data_out : out std_logic_vector (WIDTH_pixel - 1 downto 0);
        bram_data_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        -- END TESTING OF BRAM

        
        -- shift en and data in from bram... while shift is enabled it loads data
        pixel_shift_en : in std_logic;
        pixle_shift_en_out : out std_logic;
        pixel_data_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);

        pixel_0_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_1_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_2_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);

        -- read_pixel_data_en_in : in std_logic;
        --r_adr_0_in : in std_logic_vector(WIDTH_bram_adr - 1 downto 0);
        -- r_data_0_out : out std_logic_vector(WIDTH_data - 1 downto 0);

        --kernel reg bank
        -- read interface
        r_0_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_0_kernel_addr_in : in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        r_1_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_1_kernel_addr_in : in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        r_2_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_2_kernel_addr_in : in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        -- write interface
        w_0_kernel_data_in : in std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        w_0_kernel_addr_in : in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);
        write_0_kernel_data : in std_logic
    );
end memory_control;

architecture Behavioral of memory_control is
    -- reg bank


    type reg_bank is array(0 to reg_nuber - 1) of std_logic_vector(WIDTH_kernel_data - 1 downto 0);
    signal bank : reg_bank;

    type bram_t is array(0 to BRAM_size - 1) of std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal bram_s : bram_t;
    signal bram_temp : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal bram_write_en : std_logic;

    signal r_data_0_out_s : std_logic_vector(WIDTH_data - 1 downto 0);
    signal pixel_0_data_out_s : std_logic_vector(WIDTH_pixel - 1 downto 0);

    type pixel_data_shift_t is array (0 to DEPTH - 1) of std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal pixel_data_shift_s : pixel_data_shift_t;


    signal bram_en_shift_s : std_logic_vector (DEPTH - 1 downto 0);
    signal bram_en_s : std_logic;

begin
    pixel_2_data_out <= pixel_data_shift_s(2);
    pixel_1_data_out <= pixel_data_shift_s(1);
    pixel_0_data_out <= pixel_data_shift_s(0);

    pixle_shift_en_out <= bram_en_s; -- this is transfered to IP integrator bram as read enable singal
    -- *This has to be synced wtih the enable signals... the idea is to have one enable so when its active it writes "111" into shift reg, and so after one clock cycke it gives enable to the bram in data procces
    -- so the bram data in procces is delayed for one clock so that bram has time to put correct data on the data line.
    bram_data_in_proc : process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset_in = '1') then
                pixel_data_shift_s <= (others => (others => '0'));
                bram_en_s <= '0';
            else
                -- ** probably doesnt need to be synced any more... well see... connect these shift regs to add cnt shift 
                -- bram_en_shift_s(0) <= pixel_shift_en;
                -- bram_en_shift_s(1) <= bram_en_shift_s(1);
                -- bram_en_shift_s(0) <=
                -- bram_en_shift_s(0)
                bram_en_s <= pixel_shift_en;
                if (bram_en_s = '1') then               
                    pixel_data_shift_s(2) <= pixel_data_in;
                    pixel_data_shift_s(1) <= pixel_data_shift_s(2);
                    pixel_data_shift_s(0) <= pixel_data_shift_s(1);
                 end if;
            end if;
        end if;

    end process;
    
    -- This is correct... Reg bank for kernel data works.
    sync_r_w_reg_bank : process(clk) is
        begin

            if(rising_edge(clk)) then
                if(reset_in = '1') then
                    bank <= (others => (others => '0'));
                else
                    if(write_0_kernel_data = '1') then
                        bank(to_integer(unsigned(w_0_kernel_addr_in))) <= w_0_kernel_data_in;
                        
                    end if;
                    r_0_kernel_data_out <= bank(to_integer(unsigned( r_0_kernel_addr_in )));
                    r_1_kernel_data_out <= bank(to_integer(unsigned( r_1_kernel_addr_in )));
                    r_2_kernel_data_out <= bank(to_integer(unsigned( r_2_kernel_addr_in )));
                end if;

            end if;

        end process;


    bram : process (clk) is 
    begin
        if (rising_edge(clk)) then
            if (bram_en_s = '1') then
                bram_temp <= bram_s(to_integer(unsigned(bram_adr_in)));
            end if;
            if (bram_write_en = '1') then
                bram_s(to_integer(unsigned(bram_adr_in))) <= bram_data_in;
            end if;
        end if;
        
    end process;
    bram_data_out <= bram_temp;
    bram_write_en <= write_0_en_in;
end Behavioral;