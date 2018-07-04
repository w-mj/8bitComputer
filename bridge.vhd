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
signal data_t: std_logic_vector(7 downto 0);
begin
data <= data_t when put='1' else (others=>'Z');
with address select data_t <=
	"00001110" when "0000000000000000", -- moi c
	"10001111" when "0000000000000001", -- 8f
	"01111001" when "0000000000000010", -- mov a, c
	"00001110" when "0000000000000011", -- moi c
	"00010110" when "0000000000000100", -- 16
	"10000001" when "0000000000000101", -- add c
	"11010011" when "0000000000000110", -- out
	"11111110" when "0000000000000111", -- fe
	"11111111" when others;
ram_address <= address(14 downto 0);
--ram_csN <= address(15);
--ram_weN <= not load;
--ram_oeN <= not put;
--ram_address <= address(14 downto 0);
--
--digit_cs <= switch(1 downto 0);
--digit_data <= key_flag & key_data;
--set_digit <= CLK;
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