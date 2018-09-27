library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg.all;

-- 0000-7FFF: RAM
-- 8000-BFFF: Display
-- C000-FFFF: others

entity bridge is port(
	address: in std_logic_vector(15 downto 0);
	data: inout std_logic_vector(7 downto 0);
	
	ram_address: out std_logic_vector(14 downto 0);
	ram_csN, ram_weN, ram_oeN: out std_logic;
	ram_data: inout std_logic_vector(7 downto 0);
	
	digit_data: out std_logic_vector(7 downto 0);
	digit_cs: out std_logic_vector(2 downto 0);
	switch: in std_logic_vector(3 downto 0);
	key_data: in std_logic_vector(3 downto 0);
	CLK, put, load, key_flag: in std_logic;
	set_digit: out std_logic;
	
	dis_ram_addr: out std_logic_vector(13 downto 0);
	dis_ram_data: out std_logic_vector(7 downto 0);
	dis_ram_wN: out std_logic;
	
	init_addr: in std_logic_vector(14 downto 0);
	init_data: in std_logic_vector(7 downto 0);
	init_holder: in std_logic
	);
end bridge;


architecture bridge_arch of bridge is
signal data_t, ram_data_t: std_logic_vector(7 downto 0);
begin
data <= data_t when put='1' else (others=>'Z');

ram_csN <= address(15) when init_holder='0' else '0';
ram_weN <= load when init_holder='0' else '0';
ram_oeN <= put when init_holder='0' else '1';
ram_address <= address(14 downto 0) when init_holder='0' else init_addr;
ram_data <= ram_data_t when init_holder='0' else init_data;

dis_ram_addr <= address(13 downto 0);
dis_ram_wN <= not(address(15) and not address(14) and put);
dis_ram_data <= data;

process (address, put, load) begin
	set_digit <= '0';
	ram_data_t <= (others=>'Z');
	digit_cs <= (others=>'X');
	digit_data <= (others=>'X');
	if (put = '1') then
		if (address(15) = '0') then 
			data_t <= ram_data_t;
		elsif (address(15 downto 8) = "11110000") then 
			data_t <= key_data & (not switch);
		end if;
	end if;
	if (load = '1') then
		if (address(15) = '0') then
			ram_data_t <= data;
		elsif (address(15 downto 11) = "11111") then
			digit_cs <= address(10 downto 8);
			set_digit <= '1';
			digit_data <= data;
		end if;
	end if;
end process;
end bridge_arch;