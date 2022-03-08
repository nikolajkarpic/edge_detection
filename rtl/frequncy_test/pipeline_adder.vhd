----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2020 06:29:21 PM
-- Design Name: 
-- Module Name: pipelined_adder - Behavioral
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

-- This file containts VHDL code that implements a A*B WIDTH pipelined_adder
-- and it maps it to DSP cells. While the WIDTH of the multiplier is 25*18, syntesizer
-- maps it to 1 dsp cels, and if it's bigger than that syntesizer maps it to
-- more than one dsp cells.

-- Parameters:
-- WIDTHA - sets the WIDTH of operand a_i
-- WIDTHB - sets the WIDTH of operand b_i
-- SIGNED_UNSIGNED - string that determines whether multiple_acc is unsigned or
--                                   signed. If it needs to be signed, pass argument "signed"
--                                   else it will be unsigned.

entity pipelined_adder is
    generic (WIDTHA:natural:=32;
             WIDTHB:natural:=32;             
             SIGNED_UNSIGNED: string:= "signed");
    Port ( clk: in std_logic;
           a_i: in std_logic_vector (WIDTHA - 1 downto 0);
           b_i: in std_logic_vector (WIDTHB - 1 downto 0);           
           res_o: out std_logic_vector(WIDTHA - 1 downto 0));
end pipelined_adder;
architecture Behavioral of pipelined_adder is
    --------------------------------------------------------------------------------------------------------
    -- Atributes that need to be defined so Vivado synthesizer maps appropriate
    -- code to DSP cells
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- Pipeline registers.
    signal a_reg_s: std_logic_vector(WIDTHA - 1 downto 0);
    signal b_reg_s: std_logic_vector(WIDTHB - 1 downto 0);

    signal p_reg_s: std_logic_vector(WIDTHA - 1 downto 0);
    --------------------------------------------------------------------------------------------------------
begin
     process (clk) is
     begin
         if (rising_edge(clk))then
             a_reg_s <= a_i;
             b_reg_s <= b_i;
             if (SIGNED_UNSIGNED = "signed") then
                 p_reg_s <= std_logic_vector(signed(a_reg_s) + signed(b_reg_s));                 
             else
                 p_reg_s <= std_logic_vector(unsigned(a_reg_s) + unsigned(b_reg_s));                 
             end if;                          
         end if;
     end process;
     res_o <= p_reg_s;
end Behavioral;

