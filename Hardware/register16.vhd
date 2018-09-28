library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity register16 is port(
	data_in: in std_logic_vector(15 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	CLK: in std_logic;
	CLR: in std_logic:='0';
	EN: in std_logic
	);
end register16;

architecture register16_arch of register16 is
begin
C1: register8 port map(data_in=>data_in(15 downto 8), data_out=>data_out(15 downto 8), 
								CLK=>CLK, CLR=>CLR, EN=>EN);
C2: register8 port map(data_in=>data_in(7 downto 0), data_out=>data_out(7 downto 0), 
								CLK=>CLK, CLR=>CLR, EN=>EN);
end register16_arch;