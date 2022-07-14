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
        WIDTH_sum : natural := 32;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        sum_en_i : in std_logic;
        reset_in : in std_logic;
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
    signal pixel_reg : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal kernel_reg : std_logic_vector(WIDTH_kernel - 1 downto 0);
    signal multiply_next : std_logic_vector(WIDTH_pixel + WIDTH_kernel - 1 downto 0);
    signal multiply_reg : std_logic_vector(WIDTH_pixel + WIDTH_kernel - 1 downto 0);-- := ( others => '0');
    signal accumulate_reg : std_logic_vector(WIDTH_sum - 1 downto 0);
    signal accumulate_next : std_logic_vector(WIDTH_sum - 1 downto 0);--:=  (others => '0');
    
    signal accumulate_final : std_logic_vector(WIDTH_sum - 1 downto 0);
    signal resetVal :std_logic;
begin

    --combinatorial part:
    process (kernel_reg, pixel_reg, multiply_reg, accumulate_reg)
    begin

        multiply_next <= std_logic_vector(signed(unsigned(pixel_reg)) * signed(kernel_reg));
        accumulate_next <= std_logic_vector(signed(multiply_reg) + signed(accumulate_reg));
    end process;

    --sequential part:
    process (clk)
    begin
        if (rising_edge(clk)) then

            if (reset_in = '1') then
                pixel_reg <= (others => '0');
                kernel_reg <= (others => '0');
                multiply_reg <= (others => '0');
                accumulate_reg <= (others => '0');
                accumulate_final <= (others => '0');
            else
                
                --flag mechanism for enabling register inputs, when its 0 the MAC unit acumulates 0
                if (en_in = '1') then
                    pixel_reg <= pixel_in;
                    kernel_reg <= kernel_in;
--                    resetVal<='1';
                else 
                    pixel_reg <= (others => '0');
                    kernel_reg <= (others => '0');
                end if;
--                if ( resetVal = '1' ) then
--                    resetVal <= '0';
--                    pixel_reg <= (others => '0');
--                    kernel_reg <= (others => '0');
--                end if;
                if sum_en_i = '1' then -- flag to enable loading of sum to the register where it cannot be changed before FSM allows it
                    accumulate_final <= accumulate_reg;
                else
                    accumulate_final <= (others => '0');
                end if ;
                multiply_reg <= multiply_next;
                accumulate_reg <= accumulate_next;               
            end if;
        end if;
    end process;
    --dsp output:
    mul_acc_out <= accumulate_final;
end Behavioral;