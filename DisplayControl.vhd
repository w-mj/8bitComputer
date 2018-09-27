library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

-- 640*480 resolution.
-- 80*60 characters of one screen.
-- 8*16 pixels of one character.
entity DisplayControl is port (
	row, column: in std_logic_vector(11 downto 0);
	
	dis_ram_addr: out std_logic_vector(12 downto 0);
	dis_ram_data: in std_logic_vector(15 downto 0);
	
	ASC_addr: out std_logic_vector(11 downto 0);
	ASC_data: in std_logic_vector(7 downto 0);
	
	r, g, b: out std_logic
	);
end DisplayControl;

architecture DisplayControl_arch of DisplayControl is 
signal X, Y: unsigned(11 downto 0);
signal char: unsigned(7 downto 0);
signal color: std_logic_vector(7 downto 0);
signal X_offset: unsigned(2 downto 0);
begin
X <= unsigned(column);
Y <= unsigned(row);
char <= unsigned(dis_ram_data(7 downto 0));
color <= dis_ram_data(15 downto 8);

dis_ram_addr <= std_logic_vector((Y / 16) * 80 + (X / 8));
ASC_addr <= std_logic_vector(char * 16 + Y MOD 16);
r <= color(6) when ASC_data(to_integer(X MOD 8)) = '1' else color(2);
g <= color(5) when ASC_data(to_integer(X MOD 8)) = '1' else color(1);
b <= color(4) when ASC_data(to_integer(X MOD 8)) = '1' else color(0);
end;