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
use IEEE.NUMERIC_STD.all;

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
        WIDTH_conv_out : integer := 2;

        SUM_WIDTH : integer := 32 --27 actually
    );
    port (
        --clock and start/reset interface --
        clk_i : in std_logic;
        reset_in : in std_logic;
        start_in : in std_logic;
        reset_out : out std_logic;

        i_o : out std_logic_vector (WIDTH_img_size - 1 downto 0);
        j_o : out std_logic_vector (WIDTH_img_size - 1 downto 0);
        k_o : out std_logic_vector (WIDTH_kernel_size - 1 downto 0);
        l_o : out std_logic_vector (WIDTH_kernel_size - 1 downto 0);

        calculate_p_k_adr_o : out std_logic;
        calculate_conv_adr_o : out std_logic;
        mac_en_o : out std_logic;
        sum_en_o : out std_logic;
        reset_PB_o : out std_logic;
        shift_addreses_out : out std_logic;

        -- conv_en_out : out std_logic;
        -- conv_o : out std_logic_vector (1 downto 0);
        -- conv_out_adr_o : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        --ready to write output--
        ready_o : out std_logic;
        --conv done--
        done_o : out std_logic
    );
end conv_FSM;

architecture Behavioral of conv_FSM is

    type state is (idle, init, reset_j, reset_k, reset_l, calculate_addrs, wait_data_0, wait_data_1, wait_data_2, wait_data_3, mac, mac3,counters_check ,wait_conv_out_2, wait_conv_out_1, conv_out);--, inc_i, inc_j, inc_k, inc_l);
    signal next_state, current_state : state;
    signal pixel_0_val_reg, pixel_1_val_reg, pixel_2_val_reg : std_logic_vector (WIDTH_pixel - 1 downto 0);
    signal kernel_0_val_reg, kernel_1_val_reg, kernel_2_val_reg : std_logic_vector (WIDTH_kernel - 1 downto 0);


    signal i_reg, i_next_reg, j_reg, j_next_reg : std_logic_vector(WIDTH_img_size - 1 downto 0);
    signal k_reg, k_next_reg, l_reg, l_next_reg : std_logic_vector(WIDTH_kernel_size - 1 downto 0);
    signal inc_i_s, inc_j_s, inc_k_s, inc_l_s : std_logic;
begin

    i_o <= i_reg;
    j_o <= j_reg;
    k_o <= k_reg;
    l_o <= l_reg;

    -- i_next_reg <= i_reg;
    -- j_next_reg <= j_reg;
    -- k_next_reg <= k_reg;
    -- l_next_reg <= l_reg;

    registers : process (clk_i)
    begin
        if (rising_edge(clk_i)) then
            if (reset_in = '1') then
                i_reg <= (others => '0');
                j_reg <= (others => '0');
                k_reg <= (others => '0');
                l_reg <= (others => '0');
            else
                -- if inc_x_s is an enable singal for registers that is updated in FSM
                if (inc_i_s = '1') then
                    i_reg <= i_next_reg;
                end if;
                if (inc_j_s = '1') then
                    j_reg <= j_next_reg;
                end if;
                if (inc_k_s = '1') then
                    k_reg <= k_next_reg;
                end if;
                if (inc_l_s = '1') then
                    l_reg <= l_next_reg;
                end if;
            end if;
        end if;

    end process;

    fsm_sequential : process (clk_i)
    begin
        if (rising_edge(clk_i)) then
            if (reset_in = '1') then
                current_state <= idle;
                -- reset_PB_o <= '1';
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    fsm_combinational : process (current_state, i_reg, i_next_reg, j_reg, j_next_reg, k_reg, k_next_reg, l_reg, l_next_reg, start_in)
    begin
        -- default values for states
        sum_en_o <= '0';
        mac_en_o <= '0';
        ready_o <= '0';
        reset_PB_o <= '0';
        done_o <= '0';
        calculate_p_k_adr_o <= '0';
        calculate_conv_adr_o <= '0';
        reset_out <= '0';
        shift_addreses_out <= '0';

        inc_i_s <= '0';
        inc_j_s <= '0';
        inc_k_s <= '0';
        inc_l_s <= '0';

        i_next_reg <= i_reg;
        j_next_reg <= j_reg;
        k_next_reg <= k_reg;
        l_next_reg <= l_reg;

        case current_state is
            when idle =>
                ready_o <= '1';
                reset_out <= '1';
                reset_PB_o <= '1';
                if (start_in = '1') then
                    next_state <= calculate_addrs;
                else
                    next_state <= idle;
                end if;
            when init =>
                next_state <= calculate_addrs;
            when reset_j =>
                j_next_reg <= (others => '0');
                inc_j_s <= '1';
                next_state <= reset_k;
--                reset_PB_o <= '1';
            when reset_k =>
                k_next_reg <= (others => '0');
--                sum_en_o<='1';
                inc_k_s <= '1';
                reset_PB_o <= '1';                
                next_state <= reset_l;
            when reset_l =>
                l_next_reg <= (others => '0');
                inc_l_s <= '1';
                next_state <= calculate_addrs;
            when calculate_addrs =>
                calculate_p_k_adr_o <= '1';
                -- mac adr calculation
                -- mac data gather
                --shift_addreses_out <= '1';
--                mac_en_o <= '1';
                next_state <= wait_data_0;
            when wait_data_0 =>
                shift_addreses_out <= '1';
--                mac_en_o <= '1';
                next_state <= wait_data_1;
            when wait_data_1 =>
                shift_addreses_out <= '1';
--                mac_en_o <= '1';
                next_state <= wait_data_2;
             when wait_data_2 =>
                shift_addreses_out <= '1';
                next_state <= wait_data_3;
             when wait_data_3 =>
                shift_addreses_out <= '1';
--                mac_en_o <= '1';
                next_state <= mac;
            when mac =>
                next_state<= mac3;
                mac_en_o <= '1';
                
--            when mac1 =>
----                mac_en_o <= '1';
--                next_state<= mac2;
--            when mac2 =>
----            mac_en_o <= '1';
--                next_state<= mac3;
            when mac3 =>
                if (l_reg = "0110") then
                    if (k_reg = "1000") then
                        next_state <= conv_out;
                    else
                        inc_k_s <= '1';
                        k_next_reg <= std_logic_vector(unsigned(k_reg) + 1);
                        next_state <= reset_l;
                    end if;
                else
                    l_next_reg <= std_logic_vector(unsigned(l_reg) + 3);
                    inc_l_s <= '1';
                    next_state <= calculate_addrs;
                end if;
            when conv_out =>
                calculate_conv_adr_o <= '1';
                sum_en_o <= '1';
                next_state <= wait_conv_out_1;
           when wait_conv_out_1 => 
                next_state <= wait_conv_out_2;
           when wait_conv_out_2 => 
                next_state <= counters_check;
           when counters_check => 
           reset_PB_o <= '1';       
                if (j_reg = "1011010") then --make it no hard codded
                    if (i_reg = "1011010") then -- same 
--                        if (l_reg = "0110") then
--                            if (k_reg = "1000") then
--                                next_state <= idle;
--                                done_o <= '1';
--                            else 
--                                inc_k_s <= '1';
--                                k_next_reg <= std_logic_vector(unsigned(k_reg) + 1);
--                            end if;
                            
--                         else
--                            l_next_reg <= std_logic_vector(unsigned(l_reg) + 3);
--                            inc_l_s <= '1';
--                         end if;
                            next_state <= idle;
                            done_o <= '1';
                    else
                        i_next_reg <= std_logic_vector(unsigned(i_reg) + 1);
                        inc_i_s <= '1';
                        next_state <= reset_j;
                    end if;
                else
                    j_next_reg <= std_logic_vector(unsigned(j_reg) + 1);
                    inc_j_s <= '1';
                    next_state <= reset_k;
                end if;
        end case;

    end process;
end Behavioral;