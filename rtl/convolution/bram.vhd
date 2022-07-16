library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity dp_bram is
generic (
    WIDTH: integer := 8;
    ADDRESS_WIDTH: integer := 14;
    SIZE : integer := 160000
);
port (
    ckla : in std_logic;
    clkb : in std_logic;
    ena : in std_logic;
    enb : in std_logic;
    wea : in std_logic;
    web : in std_logic;
    addra : in std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
    addrb : in std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
    dia : in std_logic_vector(WIDTH-1 downto 0);
    dib : in std_logic_vector(WIDTH-1 downto 0);
    doa : out std_logic_vector(WIDTH-1 downto 0);
    dob : out std_logic_vector(WIDTH-1 downto 0)
);
end dp_bram;
architecture beh of dp_bram is
    type ram_type is array (SIZE downto 0) of std_logic_vector(WIDTH-1 downto 0);
    shared variable RAM: ram_type;
begin
    process(ckla)
    begin
        if ckla'event and ckla = '1' then
            if ena = '1' then
            doa <= RAM(conv_integer(addra));
                if wea = '1' then
                RAM(conv_integer(addra)) := dia;
                end if;
            end if;
        end if;
    end process;
    process(clkb)
    begin
        if clkb'event and clkb = '1' then
            if enb = '1' then
            dob <= RAM(conv_integer(addrb));
                if web = '1' then
                RAM(conv_integer(addrb)) := dib;
                end if;
            end if;
        end if;
    end process;
end beh;