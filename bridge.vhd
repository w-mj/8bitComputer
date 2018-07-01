library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg.all;

entity bridge is port(
	address: in std_logic_vector(15 downto 0);
	data: inout std_logic_vector(7 downto 0);
	ram_address: out std_logic_vector(14 downto 0);
	ram_data: inout std_logic_vector(7 downto 0);
	ram_csN, ram_weN, ram_oeN: out std_logic;
	digit_data: out std_logic_vector(4 downto 0);
	digit_cs: out std_logic_vector(1 downto 0);
	switch: in std_logic_vector(3 downto 0);
	key_data: in std_logic_vector(3 downto 0);
	CLK, put, load, key_flag: in std_logic;
	set_digit: out std_logic
	);
end bridge;


architecture bridge_arch of bridge is

begin
ram_csN <= address(15);
ram_weN <= not load;
ram_oeN <= not put;
ram_address <= address(14 downto 0);

digit_cs <= "10";
digit_data <= key_flag & key_data;
set_digit <= '1';
--
--process (address, put, load) begin
--	set_digit <= '0';
--	if (put = '1') then
--		if (address(15) = '0') then 
--			data <= ram_data;
--		elsif (address = "1111111111110000") then 
--			data <= switch & key_data;
--		else 
--			data <= (others=>'Z');
--		end if;
--	end if;
--	if (load = '1') then
--		if (address(15) = '0') then
--			ram_data <= data;
--		elsif (address(15 downto 2) = "11111111111111") then
--			digit_cs <= address(1 downto 0);
--			set_digit <= '1';
--			digit_data <= data(4 downto 0);
--		end if;
--	end if;
--end process;
end bridge_arch;