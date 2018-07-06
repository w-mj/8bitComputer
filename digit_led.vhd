library ieee;
use ieee.std_logic_1164.all;


entity digit_led is port(
	digit_cs: in std_logic_vector(2 downto 0);
	digit_data: in std_logic_vector(7 downto 0);
	digit_data_out: out std_logic_vector(7 downto 0);
	digit_cs_out: out std_logic_vector(3 downto 0);
	CLK, load: in std_logic
	);
end digit_led;

architecture digit_led_arch of digit_led is
signal cs_scan: std_logic_vector(3 downto 0) := "1110";
signal dig1: std_logic_vector(4 downto 0) := "00001";
signal dig2: std_logic_vector(4 downto 0) := "00010";
signal dig3: std_logic_vector(4 downto 0) := "00011";
signal dig4: std_logic_vector(4 downto 0) := "00100";
signal num: std_logic_vector(4 downto 0) := "00000";

begin
digit_cs_out <= cs_scan;
process (CLK) begin
	if (rising_edge(CLK)) then 
	case cs_scan is
		when "1110" => cs_scan<="1101";
		when "1101" => cs_scan<="1011";
		when "1011" => cs_scan<="0111";
		when "0111" => cs_scan<="1110";
		when others => cs_scan<="1110";
	end case;
	end if;

	if (rising_edge(CLK) and load = '1') then
		case digit_cs is
			when "000"=> dig1 <= digit_data(4 downto 0);
			when "001"=> dig2 <= digit_data(4 downto 0);
			when "010"=> dig3 <= digit_data(4 downto 0);
			when "011"=> dig4 <= digit_data(4 downto 0);
			when "100"=> dig1 <= "0"&digit_data(7 downto 4); dig2 <= "0"&digit_data(3 downto 0);
			when "110"=> dig3 <= "0"&digit_data(7 downto 4); dig4 <= "0"&digit_data(3 downto 0);
			when others=> null;
		end case;
	end if;
end process;

with cs_scan select num <=
	dig4 when "1110",
	dig3 when "1101",
	dig2 when "1011",
	dig1 when "0111",
	"01111" when others;

digit_data_out(7) <= num(4);
with num(3 downto 0) select
	digit_data_out(6 downto 0) <= 
		"1111110" when "0000",
		"0110000" when "0001",
		"1101101" when "0010",
		"1111001" when "0011",
		"0110011" when "0100",
		"1011011" when "0101",
		"1011111" when "0110",
		"1110000" when "0111",
		"1111111" when "1000",
		"1111011" when "1001",
		"1110111" when "1010",
		"0011111" when "1011",
		"1001110" when "1100",
		"0111101" when "1101",
		"1001111" when "1110",
		"1000111" when "1111";

end digit_led_arch;