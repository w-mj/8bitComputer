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
    "00111110" when "0000000000000000", -- mvi a, 0
    "00000000" when "0000000000000001", -- mvi a, 0
    "00000110" when "0000000000000010", -- mvi b, 1
    "00000001" when "0000000000000011", -- mvi b, 1
    "00100110" when "0000000000000100", -- mvi h, 0a
    "00001010" when "0000000000000101", -- mvi h, 0a
    "10000000" when "0000000000000110", -- add b
    "01001111" when "0000000000000111", -- mov c, a
    "01111000" when "0000000000001000", -- mov a, b
    "10111100" when "0000000000001001", -- cmp h
    "11010010" when "0000000000001010", -- jnc OVER
    "00000000" when "0000000000001011", -- jnc OVER
    "00010010" when "0000000000001100", -- jnc OVER
    "01111001" when "0000000000001101", -- mov a, c
    "00000100" when "0000000000001110", -- inr b
    "11000011" when "0000000000001111", -- jmp LOOP
    "00000000" when "0000000000010000", -- jmp LOOP
    "00000110" when "0000000000010001", -- jmp LOOP
    "01111001" when "0000000000010010", -- mov a, c
    "11010011" when "0000000000010011", -- out fc
    "11111100" when "0000000000010100", -- out fc
    "01110110" when "0000000000010101", -- hlt
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