library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity matrix is
port(clk: in std_logic;
	row:  in std_logic_vector(3 downto 0);
	col: out std_logic_vector(3 downto 0);
	keyout: out std_logic_vector(3 downto 0);
	flag: out std_logic
	);
end matrix;


architecture behave of matrix is
signal colreg: std_logic_vector(3 downto 0);
signal con: std_logic_vector(7 downto 0);
signal cnt: std_logic_vector(15 downto 0);
signal clkreg: std_logic;

begin

--分频，在1~10KHZ左右的时钟进行键盘扫描--

process(clk)
begin
	if clk'event and clk = '1' then
		if cnt = "1100001101001111" then
			cnt <= "0000000000000000";
			clkreg <= '0';
		elsif cnt = "0110000110100111" then
			cnt <= cnt + "0000000000000001";
			clkreg <= '1';
		else
			cnt <= cnt+"0000000000000001";
		end if;
	end if;
end process;

--产生列扫描信号--

process(clkreg)
begin
if clkreg'event and clkreg = '1' then
	case colreg is
		when "1110" => colreg<="1101";
		when "1101" => colreg<="1011";
		when "1011" => colreg<="0111";
		when "0111" => colreg<="1110";
		when others => colreg<="1110";
	end case;
end if;
end process;

--对行信号和列信号进行组合--

col<=colreg;
con<= colreg & row;
--对组合的扫描信号进行判断，并输出按键指示信号以及编码--
process(clkreg)
begin
if clkreg'event and clkreg = '1' then
	case con is
	when "11101110" => keyout<="0000";flag<='1';
	when "11011110" => keyout<="0001";flag<='1';
	when "10111110" => keyout<="0010";flag<='1';
	when "01111110" => keyout<="0011";flag<='1';
	when "11101101" => keyout<="0100";flag<='1';
	when "11011101" => keyout<="0101";flag<='1';
	when "10111101" => keyout<="0110";flag<='1';
	when "01111101" => keyout<="0111";flag<='1';
	when "11101011" => keyout<="1000";flag<='1';
	when "11011011" => keyout<="1001";flag<='1';
	when "10111011" => keyout<="1010";flag<='1';
	when "01111011" => keyout<="1011";flag<='1';
	when "11100111" => keyout<="1100";flag<='1';
	when "11010111" => keyout<="1101";flag<='1';
	when "10110111" => keyout<="1110";flag<='1';
	when "01110111" => keyout<="1111";flag<='1';
	when others => flag<='0';
	end case;
end if;
end process;
end behave;