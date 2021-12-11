----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2021 02:01:33 PM
-- Design Name: 
-- Module Name: data_path - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY data_path IS
    GENERIC (WIDTH : NATURAL := 8);
    PORT (
        clk : IN STD_LOGIC;
        reg_8_bit_in : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
        reg_16_bit_in : IN STD_LOGIC_VECTOR(2 * WIDTH - 1 DOWNTO 0);
        previous_multplied_value : IN STD_LOGIC_VECTOR(3 * WIDTH - 1 DOWNTO 0);
        -- sum_reg_out : OUT STD_LOGIC_VECTOR(3 * WIDTH - 1 DOWNTO 0);
        out_1: OUT std_logic_vector (1 downto 0)
    );
END data_path;

ARCHITECTURE Behavioral OF data_path IS
    SIGNAL reg_pixel_out : STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
    SIGNAL reg_kernel_out : STD_LOGIC_VECTOR(2 * WIDTH - 1 DOWNTO 0);
    SIGNAL multiply_ker_pix_out, reg_previus_s : STD_LOGIC_VECTOR(3 * WIDTH - 1 DOWNTO 0);
    SIGNAL adder_out : STD_LOGIC_VECTOR(3 * WIDTH - 1 DOWNTO 0);
    SIGNAL sign_c_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    -- sum_reg_out <= adder_out;
    pixel_reg : ENTITY work.register_8bit(Behavioral)
        GENERIC MAP(WIDTH => WIDTH)
        PORT MAP(
            clk => clk,
            in1 => reg_8_bit_in,
            out1 => reg_pixel_out

        );

    kernel_reg : ENTITY work.register_8bit(Behavioral)
        GENERIC MAP(WIDTH => 2 * WIDTH)
        PORT MAP(
            clk => clk,
            in1 => reg_16_bit_in,
            out1 => reg_kernel_out

        );

    kernel_previous_val : ENTITY work.register_8bit(Behavioral)
        GENERIC MAP(WIDTH => 3 * WIDTH)
        PORT MAP(
            clk => clk,
            in1 => previous_multplied_value,
            out1 => reg_previus_s

        );
    multiply_ker_pix : ENTITY work.simple_multiplier(Behavioral)
        GENERIC MAP(
            WIDTHA => WIDTH,
            WIDTHB => 2 * WIDTH
        )
        PORT MAP(
            clk => clk,
            a_i => reg_pixel_out,
            b_i => reg_kernel_out,
            res_o => multiply_ker_pix_out
        );

    -- adder_previous_current : ENTITY work.adder(Behavioral)
    --     GENERIC MAP(
    --         WIDTHA => 3 * WIDTH,
    --         WIDTHB => 3 * WIDTH
    --     )
    --     PORT MAP(
    --         a_i => multiply_ker_pix_out,
    --         b_i => reg_previus_s,
    --         res_o => adder_out
    --     );

    pipeline_adder_prevous_current : ENTITY work.pipelined_adder(Behavioral)
        GENERIC MAP (
            WIDTHA => 3 * WIDTH,
            WIDTHB => 3 * WIDTH
        )
        PORT MAP(
            clk => clk,
            a_i => multiply_ker_pix_out,
            b_i => reg_previus_s,
            res_o => adder_out
        );
    sign_c : entity work.sign_checker(Behavioral)
    PORT MAP(
        clk => clk,
        in1 => adder_out,
        out1 => sign_c_s
    );
    out_reg : ENTITY work.register_8bit(Behavioral)
        GENERIC MAP(WIDTH => WIDTH/4)
        PORT MAP(
            clk => clk,
            in1 => sign_c_s,
            out1 => out_1
        );

END Behavioral;