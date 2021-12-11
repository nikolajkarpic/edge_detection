----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2020 06:29:21 PM
-- Design Name: 
-- Module Name: adder - Behavioral
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

-- This file containts VHDL code that implements a A*B width adder with
-- optional number of pipeline stages. Number of pipeline stages depends on
-- implementation desires, but recomended amount is 3 or 4, because then, all
-- the register are inferred into dsp cells, otherwise the tool will use
-- flipflops inside slices for register implementation. 

-- Parameters:
-- WIDTHA - sets the width of operand a_i
-- WIDTHB - sets the width of operand b_i
-- PIPE_STAGES - sets the number of pipeline stages
-- SIGNED_UNSIGNED - string that determines whether multiple_acc is unsigned or
--                                   signed. If it needs to be signed, pass argument "signed"
--                                   else it will be unsigned.


entity adder is
    generic (WIDTHA:natural:=32;
             WIDTHB:natural:=32;             
             SIGNED_UNSIGNED: string:= "signed");
    Port (a_i: in std_logic_vector (WIDTHA - 1 downto 0);
           b_i: in std_logic_vector (WIDTHB - 1 downto 0);           
           res_o: out std_logic_vector(WIDTHA - 1 downto 0));

end adder;

architecture Behavioral of adder is
    --------------------------------------------------------------------------------------------------------
    -- Atributes that need to be defined so Vivado synthesizer maps appropriate
    -- code to DSP cells
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
    --------------------------------------------------------------------------------------------------------
begin
    signed_add: if SIGNED_UNSIGNED = "signed" generate 
                 res_o <= std_logic_vector(signed(a_i) + signed(b_i));                     
    end generate;
    unsigned_add: if SIGNED_UNSIGNED = "unsigned" generate 
                 res_o <= std_logic_vector(signed(a_i) + signed(b_i));                     
    end generate;
end Behavioral;
