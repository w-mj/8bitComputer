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


ram_csN <= address(15);
ram_weN <= not load;
ram_oeN <= not put;
ram_address <= address(14 downto 0);

process (address, put, load) begin
	set_digit <= '0';
	ram_data <= (others=>'X');
	digit_cs <= (others=>'X');
	digit_data <= (others=>'X');
	if (put = '1') then
		if (address(15) = '0') then 
		
case address is
    when "0000000000000000"=> data_t <= "11011011"; -- in f0
    when "0000000000000001"=> data_t <= "11110000"; -- in f0
    when "0000000000000010"=> data_t <= "11010011"; -- out fc
    when "0000000000000011"=> data_t <= "11111100"; -- out fc
    when "0000000000000100"=> data_t <= "11000011"; -- jmp LOOP
    when "0000000000000101"=> data_t <= "00000000"; -- jmp LOOP
    when "0000000000000110"=> data_t <= "00000000"; -- jmp LOOP
	when others=> data_t <= "01110110";  -- hlt
end case;

		elsif (address(15 downto 8) = "11110000") then 
			data_t <= switch & key_data;
		end if;
	end if;
	if (load = '1') then
		if (address(15) = '0') then
			ram_data <= data;
		elsif (address(15 downto 11) = "11111") then
			digit_cs <= address(10 downto 8);
			set_digit <= '1';
			digit_data <= data;
		end if;
	end if;
end process;
end bridge_arch;