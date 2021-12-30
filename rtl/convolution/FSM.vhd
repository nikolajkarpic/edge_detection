----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/27/2021 12:55:01 PM
-- Design Name: 
-- Module Name: conv - Behavioral
-- Project Name: Edge_detection
-- Target Devices: zybo
-- Tool Versions: 
-- Description: convolution module, it calculates 2D convolution of a kernel
--              matrix and pixel matrix. The matrices are 9x9. 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_FSM is
    generic (
        WIDTH_pixel : integer := 8;
        WIDTH_kernel : integer := 16;
        KERNEL_SIZE : integer := 9;
        WIDTH_kernel_size : integer := 4;
        DEFAULT_IMG_SIZE : integer := 100;
        WIDTH_img_size : integer := 7;
        WIDTH_bram_in_out_adr : integer := 14;
        WIDTH_kernel_adr : integer := 6;

        SUM_WIDTH : integer := 27
    );
    port (
        --clock and start/reset interface --
        clk_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;
        --image config--
        --image
        --pixel and kernel data--
        pixel_0_val_i : in std_logic_vector (WIDTH_pixel - 1 downto 0);
        pixel_1_val_i : in std_logic_vector (WIDTH_pixel - 1 downto 0);
        pixel_2_val_i : in std_logic_vector (WIDTH_pixel - 1 downto 0);
        kernel_0_val_i : in std_logic_vector (WIDTH_kernel - 1 downto 0);
        kernel_1_val_i : in std_logic_vector (WIDTH_kernel - 1 downto 0);
        kernel_2_val_i : in std_logic_vector (WIDTH_kernel - 1 downto 0);

        --pixel and kernel addres data--
        pixel_0_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_1_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        pixel_2_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        kernel_0_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_1_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        kernel_2_adr_o : out std_logic_vector (WIDTH_kernel_adr - 1 downto 0);
        --ip output data and addres--
        conv_o : out std_logic_vector (1 downto 0);
        conv_out_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        --ready to write output--
        ready_o : out std_logic;
        --conv done--
        done_o : out std_logic
    );
end conv_FSM;

architecture Behavioral of conv_FSM is

    type state is (idle, init, reset_j, reset_k, reset_l, mac_adr_and_data, mac, conv_out);
    signal next_state, current_state : state;
    signal pixel_0_val_reg, pixel_1_val_reg, pixel_2_val_reg : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal kernel_0_val_reg, kernel_1_val_reg, kernel_2_val_reg : std_logic_vector (WIDTH_kernel - 1 downto 0);

    signal sum : std_logic_vector(SUM_WIDTH - 1 downto 0);

    signal i_reg, i_next_reg, j_reg, j_next_reg : std_logic_vector(WIDTH_img_size - 1 downto 0);
    signal k_reg, k_next_reg, l_reg, l_next_reg : std_logic_vector(WIDTH_kernel_size - 1 downto 0);
begin

    registers : process (clk_i)
    begin
        if (reset_i = '1') then
            i_reg <= (others => '0');
            j_reg <= (others => '0');
            k_reg <= (others => '0');
            l_reg <= (others => '0');
        else
            i_reg <= i_next_reg;
            j_reg <= j_next_reg;
            k_reg <= k_next_reg;
            l_reg <= l_next_reg;
        end if;
    end process;

    fsm_sequential : process (clk_i)
    begin
        if (reset_i = '1') then
            current_state <= idle;
        else
            current_state <= next_state;
        end if;
    end process;

    fsm_combinational : process (current_state, i_reg, i_next_reg, j_reg, j_next_reg, k_reg, k_next_reg, l_reg, l_next_reg)
    begin
        --next_state <= current_state;
        ready_o <= '0';
        done_o <= '0';
        case current_state is
            when idle =>
                ready_o <= '1';

                if (start_i = '1') then
                    next_state <= init;
                else
                    next_state <= idle;
                end if;
            when init =>
                next_state <= mac;
            when reset_j =>
                j_next_reg <= (others => '0');
                next_state <= reset_k;
            when reset_k =>
                k_next_reg <= (others => '0');
                sum <= (others => '0');
                next_state <= reset_l;
            when reset_l =>
                l_next_reg <= (others => '0');
                next_state <= mac_adr_and_data;
            when mac_adr_and_data =>
                -- mac adr calculation
                -- mac data gather
                next_state <= mac;
            when mac =>
                --mac 0
                --mac 1
                --mac 2
                if (i_reg = "110") then
                    if (k_reg = "1000") then
                        next_state <= conv_out;
                    else
                        k_next_reg <= std_logic_vector(unsigned(k_reg) + 1);
                        next_state <= reset_l;
                    end if;
                else
                    l_next_reg <= std_logic_vector(unsigned(l_reg) + 3);
                    next_state <= mac_adr_and_data;
                end if;

            when conv_out =>
                --conv_out_adr_calculation
                --sign check
                if (j_reg = "1100100") then
                    if( i_reg = "1100100") then
                        next_state <= idle;
                    else
                        i_next_reg <= std_logic_vector(unsigned(i_reg) + 1);
                        next_state <= reset_j;
                    end if;
                else
                    j_next_reg <= std_logic_vector(unsigned(j_reg) + 1);
                    next_state <= reset_k;
                end if;
        end case;

    end process;

end Behavioral;