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
	digit_data: out std_logic_vector(7 downto 0);
	digit_cs: out std_logic_vector(2 downto 0);
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
    "00001110" when "0000000000000000", -- mvi c, 1f
    "00011111" when "0000000000000001", -- mvi c, 1f
    "01111001" when "0000000000000010", -- mov a, c
    "00010110" when "0000000000000011", -- mvi d, 01
    "00000001" when "0000000000000100", -- mvi d, 01
    "10010010" when "0000000000000101", -- sub d
    "11010011" when "0000000000000110", -- out fe
    "11111110" when "0000000000000111", -- out fe
    "11000011" when "0000000000001000", -- jmp XX
    "00000000" when "0000000000001001", -- jmp XX
    "00000011" when "0000000000001010", -- jmp XX
    "01110110" when "0000000000001011", -- hlt
	 "01110110" when others;  -- hlt

ram_csN <= address(15);
ram_weN <= not load;
ram_oeN <= not put;
ram_address <= address(14 downto 0);

process (address, put, load) begin
	set_digit <= '0';
	ram_data <= (others=>'X');
	digit_cs <= (others=>'X');
	digit_data <= (others=>'X');
	--	if (put = '1') then
--		if (address(15) = '0') then 
--			data <= ram_data;
--		elsif (address = "1111111111110000") then 
--			data <= switch & key_data;
--		else 
--			data <= (others=>'Z');
--		end if;
--	end if;
	if (load = '1') then
		if (address(15) = '0') then
			ram_data <= data;
		else
			digit_cs <= address(10 downto 8);
			set_digit <= '1';
			digit_data <= data;
		end if;
	end if;
end process;
end bridge_arch;