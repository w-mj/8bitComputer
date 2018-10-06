library ieee;
use ieee.std_logic_1164.all;
 -- 115200 bps
entity Serial is port (
	clk: in std_logic;
	rx: in std_logic;
	data: out std_logic_vector(7 downto 0);
	data_ok: out std_logic := '0'
	);
end Serial;
	
architecture Serial_arch of Serial is 
signal waiting: boolean := true;
signal data_buff: std_logic_vector(7 downto 0) := "00000000"; 
signal read_cnt: integer := 0;
begin
data <= data_buff;
process(clk) begin
	if (clk'event and clk = '0') then
		data_ok <= '0';
		if (waiting = true) then 
			if (rx = '0') then
				waiting <= false;
			end if;
		else
			if (read_cnt /= 8) then
				data_buff(read_cnt) <= rx;
				read_cnt <= read_cnt + 1;
			else
				data_ok <= '1';
				read_cnt <= 0;
				waiting <= true;
			end if;
		end if;
	end if;
end process;

end;