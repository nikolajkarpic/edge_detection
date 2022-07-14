----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2022 05:32:05 PM
-- Design Name: 
-- Module Name: mac_v2 - Behavioral
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

entity mac_v2 is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 24;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        pixel_0_in, pixel_1_in, pixel_2_in : in std_logic_vector (WIDTH_pixel - 1 downto 0);
        kernel_0_in, kernel_1_in, kernel_2_in : in std_logic_vector (WIDTH_kernel - 1 downto 0);
        clk : in std_logic;
        enable_in : in std_logic;
        reset_in : in std_logic;
        sum_final_en : in std_logic;
        sum0_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum1_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum2_out : out std_logic_vector (WIDTH_sum - 1 downto 0);
        sum_out : out std_logic_vector (WIDTH_sum - 1 downto 0));
end mac_v2;

architecture Behavioral of mac_v2 is
    signal accumulate_en, sum_write_en : std_logic;
    signal sum_0_s, sum_1_s, sum_2_s, sum_0_n_s, sum_1_n_s, sum_2_n_s : std_logic_vector(WIDTH_sum - 1 downto 0);
    type state_t is (multiply, sum, idle, w); --, sum_final);
    signal state_next_s, state_current_s : state_t;
    signal acumulator_s, acumulator_n_s, sum_final_s : std_logic_vector(WIDTH_sum - 1 downto 0);
begin
    registers : process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset_in = '1') then
                sum_0_s <= (others => '0');
                sum_1_s <= (others => '0');
                sum_2_s <= (others => '0');
                acumulator_s <= (others => '0');
                sum_final_s <= (others => '0');
                state_current_s <= idle;
            else
                state_current_s <= state_next_s;
                if sum_write_en = '1' then
                    sum_0_s <= sum_0_n_s;
                    sum_1_s <= sum_1_n_s;
                    sum_2_s <= sum_2_n_s;
                end if;
                if accumulate_en = '1' then
                    acumulator_s <= acumulator_n_s;
                end if;
                -- if  sum_final_en = '1' then
                --     sum_out <= acumulator_s;
                -- else 
                -- sum_out <= (others=>'0');
                -- end if;
            end if;
        end if;

    end process;

    -- fsm_sequential : process (clk)
    -- begin
    --     if (rising_edge(clk)) then
    --         if (reset_in = '1') then
    --             state_current_s <= idle;
    --         else
    --             state_current_s <= state_next_s;
    --         end if;
    --     end if;
    -- end process;

    fsm_combinational : process (state_next_s, state_current_s)
    begin
        sum_0_n_s <= (others => '0');
        sum_1_n_s <= (others => '0');
        sum_2_n_s <= (others => '0');
        sum_write_en <= '0';
        accumulate_en <= '0';
        acumulator_n_s <= acumulator_s;
        case state_current_s is
            when idle =>
                sum_0_n_s <= (others => '0');
                sum_1_n_s <= (others => '0');
                sum_2_n_s <= (others => '0');
                if (enable_in = '1') then
                    state_next_s <= multiply;
                else
                    state_next_s <= idle;
                end if;

            when multiply =>
                sum_write_en <= '1';
                sum_0_n_s <= std_logic_vector(signed(pixel_0_in) * signed(kernel_0_in));
                sum_1_n_s <= std_logic_vector(signed(pixel_1_in) * signed(kernel_1_in));
                sum_2_n_s <= std_logic_vector(signed(pixel_2_in) * signed(kernel_2_in));
                state_next_s <= w;
            when w =>
            state_next_s <= sum; 
            when sum =>
                acumulator_n_s <= std_logic_vector(signed(sum_0_s) + signed(sum_1_s) + signed(sum_2_s) + signed(acumulator_s));
                accumulate_en <= '1';
                state_next_s <= idle;
                --state_next_s <= accumulate;
                --when accumulate=>

                --     if (sum_final_en = '1') then
                --         state_next_s <= sum_final;
                --     else
                --         state_next_s <= idle;
                --     end if;
                -- when sum_final =>
                --     
        end case;
    end process;
    sum_out <= acumulator_s;
    sum0_out <= sum_0_n_s;
    sum1_out <= sum_1_n_s;
    sum2_out <= sum_2_n_s;
end Behavioral;