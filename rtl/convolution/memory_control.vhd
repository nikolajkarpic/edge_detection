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
        WIDTH_kernel_data: natural := 16;
        WIDTH_kernel_addr: natural := 8;
        reg_nuber: natural := 81;
        num_of_pixels : integer := 8;
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        size : integer := 22579;
        WIDTH_num_of_pixels_in_bram : integer := 3;
        WIDTH_pixel : integer := 8;
        DEPTH : integer := 3;

        WIDTH_bram_adr : integer := 15
    );
    port (
        -- clocking
        clk : in std_logic;
        reset_in: in std_logic;

        --piso

        shift_in : in std_logic;
        rst_in: in std_logic;
        write_en: in std_logic;

        --write data to BRAM
        write_0_en_in : in std_logic;
        w_data_0_in : in std_logic_vector(WIDTH_data - 1 downto 0);
        w_adr_0_in : in std_logic_vector(WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
        --read data for bram
        pixel_0_bram_adr_in : in std_logic_vector (WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
        pixel_0_bram_slice_adr_in : in std_logic_vector (WIDTH_num_of_pixels_in_bram - 1 downto 0);

        pixel_1_bram_adr_in : in std_logic_vector (WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
        pixel_1_bram_slice_adr_in : in std_logic_vector (WIDTH_num_of_pixels_in_bram - 1 downto 0);

        pixel_2_bram_adr_in : in std_logic_vector (WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);
        pixel_2_bram_slice_adr_in : in std_logic_vector (WIDTH_num_of_pixels_in_bram - 1 downto 0);

        pixel_0_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_1_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        pixel_2_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);


        read_pixel_data_en_in : in std_logic;
        --r_adr_0_in : in std_logic_vector(WIDTH_bram_adr - 1 downto 0);
        r_data_0_out : out std_logic_vector(WIDTH_data - 1 downto 0);

        --kernel reg bank
        -- read interface
        r_0_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_0_kernel_addr_in: in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        r_1_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_1_kernel_addr_in: in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        r_2_kernel_data_out : out std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        r_2_kernel_addr_in: in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);

        -- write interface
        w_0_kernel_data_in : in std_logic_vector(WIDTH_kernel_data - 1 downto 0);
        w_0_kernel_addr_in: in std_logic_vector(WIDTH_kernel_addr - 1 downto 0);
        write_0_kernel_data: in std_logic
    );
end memory_control;

architecture Behavioral of memory_control is
    -- reg bank
    type reg_bank is array( 0 to reg_nuber - 1 ) of std_logic_vector( WIDTH_kernel_data - 1 downto 0 );
    signal bank : reg_bank;
    -- bram
    type ram_type is array(0 to size - 1) of std_logic_vector(WIDTH_data - 1 downto 0);
    signal bram : ram_type := (others => (others => '0'));
    --BRAM SLICE DATA
    type pixel_type is array (0 to num_of_pixels) of std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal pixel_data : pixel_type := (others => (others => '0'));

    signal r_data_0_out_s : std_logic_vector(WIDTH_data - 1 downto 0);
    signal pixel_0_data_out_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    --PISO
    --bram adr
    type piso_bram_adr_t is array (0 to DEPTH - 1) of std_logic_vector(WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram  - 1 downto 0);
    signal piso_bram_adr_s : piso_bram_adr_t;
    signal sereal_output_s : std_logic_vector(WIDTH_bram_adr - WIDTH_num_of_pixels_in_bram - 1 downto 0);

    --bram adr in slice
    type piso_bram_adr_slice_t is array (0 to DEPTH - 1) of std_logic_vector(WIDTH_num_of_pixels_in_bram - 1 downto 0);
    signal piso_bram_adr_slice_s : piso_bram_adr_slice_t;
    signal sereal_output_slice_s : std_logic_vector(WIDTH_num_of_pixels_in_bram - 1 downto 0);

    --SIPO pixel data
    signal en_gen_s : std_logic_vector(DEPTH - 1 downto 0) := (0 => '1',
    others => '0');
    signal read_en_s : std_logic;
    signal state_s : std_logic_vector(DEPTH * WIDTH_pixel - 1 downto 0) := (others => '0');


begin

    -- pixel within one 64 bit bram slice logic

    pixel_data(0) <= r_data_0_out_s (7 downto 0);
    pixel_data(1) <= r_data_0_out_s (15 downto 8);
    pixel_data(2) <= r_data_0_out_s (23 downto 16);
    pixel_data(3) <= r_data_0_out_s (31 downto 24);
    pixel_data(4) <= r_data_0_out_s (39 downto 32);
    pixel_data(5) <= r_data_0_out_s (47 downto 40);
    pixel_data(6) <= r_data_0_out_s (55 downto 48);
    pixel_data(7) <= r_data_0_out_s (63 downto 56);

    pixel_0_data_out_s <= pixel_data(to_integer(unsigned(sereal_output_slice_s)));
    -- pixel_1_data_out <= pixel_data(to_integer(unsigned(pixel_1_bram_slice_adr_in)));
    -- pixel_2_data_out <= pixel_data(to_integer(unsigned(pixel_2_bram_slice_adr_in)));--when read_pixel_data_en_in = '1' else (others=>'0');


    BRAM_memory_port0 : process (clk)
    begin

        if (rising_edge(clk)) then

            if (write_0_en_in = '1') then
                bram(to_integer(unsigned(w_adr_0_in))) <= w_data_0_in;
            end if;
            if (read_pixel_data_en_in = '1') then
                r_data_0_out_s <= bram(to_integer(unsigned(sereal_output_s)));
            end if;
        end if;
    end process;

    -- reg_bank : process(clk) is
    --     begin
        
    --         if(rising_edge(clk)) then
    --             if(reset_in = '1') then
    --                 bank <= (others => (others => '0'));
    --             else
    --                 if(write_0_kernel_data = '1') then
    --                     bank(to_integer(unsigned(w_0_kernel_addr_in))) <= w_0_kernel_data_in;
    --                 end if;
    --             end if;
                
    --         end if;
        
    --     end process;

    --     r_0_kernel_data_out <= bank(to_integer(unsigned( r_0_kernel_addr_in )));
    --     r_1_kernel_data_out <= bank(to_integer(unsigned( r_1_kernel_addr_in )));
    --     r_2_kernel_data_out <= bank(to_integer(unsigned( r_2_kernel_addr_in )));


        piso_reg_bram_adr : process (clk) is
            begin
                if rising_edge(clk) then
                    if rst_in = '1' then
                        piso_bram_adr_s(0) <= (others => '0');
                        piso_bram_adr_s(1) <= (others => '0');
                        piso_bram_adr_s(2) <= (others => '0');
                    elsif write_en = '1' then
                        piso_bram_adr_s(0) <= pixel_0_bram_adr_in;
                        piso_bram_adr_s(1) <= pixel_1_bram_adr_in;
                        piso_bram_adr_s(2) <= pixel_2_bram_adr_in;
                    elsif shift_in = '1' then
                        sereal_output_s <= piso_bram_adr_s(2);
                        piso_bram_adr_s(2) <= piso_bram_adr_s(1);
                        piso_bram_adr_s(1) <= piso_bram_adr_s(0);
                        piso_bram_adr_s(0) <= (others => '0');
                    end if;
                end if;
            end process;

            
            --ovaj deo nisam siguran da treba vrlo verovatno to moze kombinaciono 131- 133 linija koda
            piso_reg_bram_slice_adr : process (clk) is
                begin
                    if rising_edge(clk) then
                        if rst_in = '1' then
                            piso_bram_adr_slice_s(0) <= (others => '0');
                            piso_bram_adr_slice_s(1) <= (others => '0');
                            piso_bram_adr_slice_s(2) <= (others => '0');
                        elsif write_en = '1' then
                            piso_bram_adr_slice_s(0) <= pixel_0_bram_slice_adr_in;
                            piso_bram_adr_slice_s(1) <= pixel_1_bram_slice_adr_in;
                            piso_bram_adr_slice_s(2) <= pixel_2_bram_slice_adr_in;
                        elsif shift_in = '1' then
                            sereal_output_slice_s <= piso_bram_adr_slice_s(2);
                            piso_bram_adr_slice_s(2) <= piso_bram_adr_slice_s(1);
                            piso_bram_adr_slice_s(1) <= piso_bram_adr_slice_s(0);
                            piso_bram_adr_slice_s(0) <= (others => '0');
                        end if;
                    end if;
                end process;


                sipo_reg : process (clk) is
                    begin
                        if rising_edge(clk) then
                            if shift_in = '1' then
                                en_gen_s <= en_gen_s(0) & en_gen_s(DEPTH - 1 downto 1);
                                state_s <= pixel_0_data_out_s & state_s(DEPTH * WIDTH_pixel - 1 downto WIDTH_pixel);
                            elsif rst_in = '1' then
                                state_s <= (others => '0');
                                en_gen_s <= (0 => '1', others => '0');
                            end if;
                        end if;
                    end process;
                    

                    -- read_en_s <= en_gen_s(0);
                    -- if read_en_s = '1' then
                        pixel_0_data_out <= state_s(DEPTH * WIDTH_pixel - 1 downto (DEPTH - 1) * WIDTH_pixel);
                        pixel_1_data_out <= state_s((DEPTH - 1) * WIDTH_pixel - 1 downto (DEPTH - 2) * WIDTH_pixel);
                        pixel_2_data_out <= state_s((DEPTH - 2) * WIDTH_pixel - 1 downto (DEPTH - 3) * WIDTH_pixel);
                    -- else 
                    --     pixel_0_data_out <= (others => '0');
                    --     pixel_1_data_out <= (others => '0');
                    --     pixel_2_data_out <= (others => '0');
                    -- end if;
end Behavioral;