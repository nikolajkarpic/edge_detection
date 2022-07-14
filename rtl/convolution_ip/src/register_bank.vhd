----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2022 11:53:35 PM
-- Design Name: 
-- Module Name: register_bank - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_bank is
    generic(
        WIDTH_data: natural := 16;
        WIDTH_addr: natural := 8;
        reg_nuber: natural := 81
    );
    Port (
        --clocking and reset
        clk : in std_logic;
        reset_in: in std_logic;

        -- read interface
        r_0_data_out : out std_logic_vector(WIDTH_data - 1 downto 0);
        r_0_addr_in: in std_logic_vector(WIDTH_addr - 1 downto 0);

        r_1_kernel_data_out : out std_logic_vector(WIDTH_data - 1 downto 0);
        r_1_addr_in: in std_logic_vector(WIDTH_addr - 1 downto 0);

        r_2_data_out : out std_logic_vector(WIDTH_data - 1 downto 0);
        r_2_addr_in: in std_logic_vector(WIDTH_addr - 1 downto 0);

        -- write interface
        w_0_data_in : in std_logic_vector(WIDTH_data - 1 downto 0);
        w_0_addr_in: in std_logic_vector(WIDTH_addr - 1 downto 0);
        write_0_data: in std_logic

     );
end register_bank;

architecture Behavioral of register_bank is

type reg_bank is array( 0 to reg_nuber - 1 ) of std_logic_vector( WIDTH_data - 1 downto 0 );
signal bank : reg_bank;

begin

    Write_reg_bank : process(clk) is
        begin
        
            if(rising_edge(clk)) then
                if(reset_in = '1') then
                    bank <= (others => (others => '0'));
                else
                    if(write_0_data = '1') then
                        bank(to_integer(unsigned(w_0_addr_in))) <= w_0_data_in;
                    end if;
                end if;
                
            end if;
        
        end process;


        r_0_data_out <= bank(to_integer(unsigned( r_0_addr_in )));
        r_1_kernel_data_out <= bank(to_integer(unsigned( r_1_addr_in )));
        r_2_data_out <= bank(to_integer(unsigned( r_2_addr_in )));
end Behavioral;
