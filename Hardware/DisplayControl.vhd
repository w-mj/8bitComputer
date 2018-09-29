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
	dis_ram_data: in std_logic_vector(7 downto 0);
	
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
signal res_1: std_logic_vector(23 downto 0);
signal res_2: std_logic_vector(15 downto 0);
begin
X <= unsigned(column);
Y <= unsigned(row);
char <= unsigned(dis_ram_data);

res_1 <= std_logic_vector((Y / 16) * 80 + (X / 8));  -- determin which char.
dis_ram_addr <= res_1(12 downto 0); 
res_2 <= std_logic_vector(char * 16 + Y MOD 16);  -- get line of the char.
ASC_addr <= res_2(11 downto 0);
process (ASC_data, X, Y)
	variable X_o, Y_o: integer;
begin
	X_o := to_integer(8 - (X MOD 8));
	Y_o := to_integer(Y MOD 16);
--	if (X_o = 0 or X_o = 7 or Y_o = 0 or Y_o = 15) then
--		r <= '1';
--		g <= '0';
--		b <= '0';
--	else
		r <= ASC_data(X_o);
		g <= ASC_data(X_o);
		b <= ASC_data(X_o);
--	end if;
end process;

end;