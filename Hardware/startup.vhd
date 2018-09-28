library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity startup is port(
	CLK: in std_logic;
	rom_addr: out std_logic_vector(14 downto 0);
	rom_data: out std_logic_vector(7 downto 0);
	ram_addr: out std_logic_vector(11 downto 0);
	ram_data: in std_logic_vector(7 downto 0);
	hold: out std_logic;
	reset: in std_logic
	);
end startup;

architecture startup_arch of startup is 
signal hold_s: std_logic := '1';
signal addr_cnt: std_logic_vector(11 downto 0) := (others=>'0');
begin
rom_data <= ram_data;
rom_addr <= "000" & addr_cnt;
ram_addr <= addr_cnt;
hold <= hold_s;
process(CLK) begin
	if (CLK'event and CLK = '0') then 
		if (reset = '0') then 
			addr_cnt <= (others=>'0');
			hold_s <= '1';
		elsif (hold_s = '1') then
			addr_cnt <= std_logic_vector(unsigned(addr_cnt) + 1);
			if (addr_cnt = "111111111111") then 
				hold_s <= '0';
			end if;
		end if;
	end if;
end process;
end startup_arch;