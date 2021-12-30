----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nikolaj Karpic ee 142/2017
-- 
-- Create Date: 12/30/2021 03:30:03 PM
-- Design Name: 
-- Module Name: accumulate_sum - Behavioral
-- Project Name: edge_detection
-- Target Devices: 
-- Tool Versions: 
-- Description: Adds up final results of 3 MAC units.
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity accumulate_sum is
    generic (
        WIDTH_sum : natural := 32;
        SIGNED_UNSIGNED : string := "signed"
    );
    port (
        rst_i : in std_logic;
        en_in : in std_logic;
        clk : in std_logic;
        sum_0_in: in std_logic_vector(WIDTH_sum - 1 downto 0);
        sum_1_in: in std_logic_vector(WIDTH_sum - 1 downto 0);
        sum_2_in: in std_logic_vector(WIDTH_sum - 1 downto 0);
        sum_out: out std_logic_vector(WIDTH_sum - 1 downto 0)
    );

end accumulate_sum;

architecture Behavioral of accumulate_sum is

    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";

    signal sum_next_reg, sum_reg, sum_1_reg, sum_2_reg, sum_0_reg, sum_1_next_reg, sum_2_next_reg, sum_0_next_reg: std_logic_vector(WIDTH_sum - 1 downto 0);


begin

    sum_0_next_reg<= sum_0_in;
    sum_1_next_reg<= sum_1_in;
    sum_2_next_reg<= sum_2_in;

    process (sum_next_reg, sum_1_reg, sum_2_reg, sum_0_reg)
    begin
        if (SIGNED_UNSIGNED = "unsigned") then
            sum_next_reg <= std_logic_vector(unsigned(sum_0_reg) + unsigned(sum_1_reg) + unsigned(sum_2_reg));
        else
            sum_next_reg <= std_logic_vector(signed(sum_0_reg) + signed(sum_1_reg) + signed(sum_2_reg));
        end if;
    end process;

    process (clk)
    begin
        if (rising_edge(clk)) then

            if (rst_i = '1') then
                sum_reg <= (others => '0');
                sum_0_reg <= (others => '0');
                sum_1_reg <= (others => '0');
                sum_2_reg <= (others => '0');
            else
                if (en_in = '1') then
                    sum_0_reg <= sum_0_next_reg;
                    sum_1_reg <= sum_1_next_reg;
                    sum_2_reg <= sum_2_next_reg;

                end if;
                sum_reg <= sum_next_reg;
            end if;

        end if;
    end process;
    

    sum_out <= sum_reg;
end Behavioral;
