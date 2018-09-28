library ieee;
use ieee.std_logic_1164.all;

entity temp_reg is port(
	to_data: inout std_logic_vector(7 downto 0);
	to_alu: out std_logic_vector(7 downto 0);
	EN, CLK, put, CLR: in std_logic
	);
end temp_reg;

architecture temp_reg_arch of temp_reg is
signal data: std_logic_vector(7 downto 0);
begin
	to_data <= data when put='1' else "ZZZZZZZZ";
	to_alu <= data;
	process(EN, CLK) begin
		if (CLR = '0') then
			if (EN='1' and rising_edge(CLK)) then
				data <= to_data;
			end if;
		else 
			data <= (others=>'0');
		end if;
	end process;
end temp_reg_arch;
