library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity startup is port(
	CLK: in std_logic;
	reset_CPU: out std_logic;
	key_flag: in std_logic;
	key_data, switch: in std_logic_vector(3 downto 0);
	address_ram: out std_logic_vector(14 downto 0);
	address_rom: out std_logic_vector(11 downto 0);
	data_ram: out std_logic_vector(7 downto 0);
	data_rom: in std_logic_vector(7 downto 0);
	ram_WEN: out std_logic;
	reset_key: in std_logic;
	load, put: out std_logic
	);
end startup;

architecture startup_arch of startup is 
signal addr_rom: std_logic_vector(11 downto 0);
signal addr_ram: std_logic_vector(14 downto 0);
signal ready: std_logic;
signal init_finish: std_logic := '0';
begin
address_ram <= addr_ram;
address_rom <= addr_rom;
data_ram <= data_rom;

process(CLK, reset_key) begin
	if (rising_edge(CLK)) then
		if (reset_key = '0') then
			addr_rom <= switch & "00000000";
			addr_ram <= (others=>'0');
			reset_CPU <= '1';
			init_finish <= '0';
			ready <= '0';
		elsif (init_finish = '0') then
			if(ready = '0') then
				addr_rom <= addr_rom + '1';
				addr_ram <= addr_ram + '1';
				ram_WEN <= '1';
				ready <= '1';
			else
				ram_WEN <= '0';
				ready <= '0';
				if (data_rom = "01110110") then -- hlt;
					init_finish <= '1';
					reset_CPU <= '0';
				end if;
			end if;
		else
			reset_CPU <= '0';
		end if;
	end if;
end process;
end startup_arch;