----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nikolaj Karpic ee 142/2017
-- 
-- Create Date: 12/30/2021 03:11:49 PM
-- Design Name: 
-- Module Name: MAC - Behavioral
-- Project Name: edge_detection
-- Target Devices: 
-- Tool Versions: 
-- Description: multiply and accumulate unit.
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

entity MAC is
    generic (
        WIDTH_pixel : natural := 8;
        WIDTH_kernel : natural := 16;
        WIDTH_sum : natural := 24;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        sum_en_i : in std_logic;
        rst_i : in std_logic;
        en_in : in std_logic;
        clk : in std_logic;
        pixel_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        kernel_in : in std_logic_vector(WIDTH_kernel - 1 downto 0);
        mul_acc_out : out std_logic_vector(WIDTH_sum - 1 downto 0) --multiply accumulate 
    );
end MAC;

architecture Behavioral of MAC is
    --attributes needed for Vivado to map code to DPS cells:
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    --pipeline registers:
    signal pixel_reg, pixel_next : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal kernel_reg, kernel_next : std_logic_vector(WIDTH_kernel - 1 downto 0);
    signal multiply_next : std_logic_vector(WIDTH_pixel + WIDTH_kernel - 1 downto 0);
    signal multiply_reg : std_logic_vector(WIDTH_pixel + WIDTH_kernel - 1 downto 0) := (others => '0');
    signal accumulate_next, accumulate_final : std_logic_vector(WIDTH_sum - 1 downto 0);
    signal accumulate_reg : std_logic_vector(WIDTH_sum - 1 downto 0) := (others => '0');
    
begin

    kernel_next <= kernel_in;
    pixel_next <= pixel_in;

    --combinatorial part:
    process (kernel_reg, pixel_reg, multiply_reg, accumulate_reg)
    begin
        if (SIGNED_UNSIGNED = "unsigned") then
            multiply_next <= std_logic_vector(unsigned(pixel_reg) * unsigned(kernel_reg));
            accumulate_next <= std_logic_vector(unsigned(multiply_reg) + unsigned(accumulate_reg));
        else
            multiply_next <= std_logic_vector(signed(pixel_reg) * signed(kernel_reg));
            accumulate_next <= std_logic_vector(signed(multiply_reg) + signed(accumulate_reg));
        end if;
    end process;

    --sequential part:
    process (clk)
    begin
        if (rising_edge(clk)) then

            if (rst_i = '1') then
                pixel_reg <= (others => '0');
                kernel_reg <= (others => '0');
                multiply_reg <= (others => '0');
                accumulate_reg <= (others => '0');
                accumulate_final <= (others => '0');
            else
                if (en_in = '1') then
                    pixel_reg <= pixel_next;
                    kernel_reg <= kernel_next;
                end if;
                -- if (sum_en_i = '1') then
                --     accumulate_final <= accumulate_reg;
                -- else
                --     accumulate_final <= (others => '0');
                -- end if;
                multiply_reg <= multiply_next;
                accumulate_reg <= accumulate_next;
            end if;

        end if;
    end process;
    --dsp output:
    mul_acc_out <= accumulate_reg;
end Behavioral;