----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 12:12:22 AM
-- Design Name: 
-- Module Name: singe_port_bram - Behavioral
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

entity singe_port_bram is
    generic(
        WIDTH_data: natural := 64;
        WIDTH_adr: natural := 18;
        size : natural := 180625
    );
  Port (
      --clocking adn reset
      clk : in std_logic;

    -- input data interface
      write_0_in : in std_logic;
      w_data_0_in : in std_logic_vector(WIDTH_data - 1 downto 0);
      w_adr_0_in  : in std_logic_vector(WIDTH_adr - 1 downto 0);

    --output data interface
    r_adr_0_in  : in std_logic_vector(WIDTH_adr - 1 downto 0);
    r_data_0_out : out std_logic_vector(WIDTH_data - 1 downto 0)

   );
end singe_port_bram;

architecture Behavioral of singe_port_bram is

    type ram_type is array(0 to size - 1) of std_logic_vector(WIDTH_data - 1 downto 0);
    signal bram : ram_type  := (others => (others => '0'));
    
begin

    memory_port0 : process(clk)
begin
   
    if(rising_edge(clk)) then

        if(write_0_in = '1') then
            bram(to_integer(unsigned(w_adr_0_in))) <= w_data_0_in;
        end if;
        
        r_data_0_out <= bram(to_integer(unsigned(r_adr_0_in)));
        
    end if;

end process;

end Behavioral;
