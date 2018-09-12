library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

-- 640*480@60HZ
-- 80*25 characters, 8*16 for one character.
entity vga is port (
	mem_addr: out std_logic_vector(10 downto 0);  -- 11 bit 2k 
	mem_data: in std_logic_vector(7 downto 0);
	mod_addr: out std_logic_vector(10 downto 0);  -- 16*128 = 2k
	mod_data: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	r, g, b: out std_logic;
	vs, hs: out std_logic
);
end vga;

architecture vga_arch of vga is 
signal h_cnt: integer range 0 to 800 := 0;
signal v_cnt: integer range 0 to 525 := 0;
signal char_h_cnt: integer range 0 to 8 := 0;
signal char_v_cnt: integer range 0 to 16 := 0;
signal char_start_pos: integer range 0 to 2000 := 0;
signal char_line_pos: integer range 0 to 80 :=0;

begin

mem_addr <= std_logic_vector(to_unsigned(char_line_pos + char_start_pos, 11));
mod_addr <= mem_data(6 downto 0) & std_logic_vector(to_unsigned(char_v_cnt, 4));
g <= mod_data(char_h_cnt);

process (clk) begin
	if (v_cnt < 35 or v_cnt >= 515) then 
		if (v_cnt < 2) then
			vs <= '0';
		else 
			vs <= '1';
		end if;
		v_cnt <= v_cnt + 1;
		if (v_cnt = 525) then 
			v_cnt <= 0;
		end if;
		
	else 
		if (h_cnt < 144 or h_cnt > 784) then
			if (h_cnt < 96) then
				hs <= '0';
			else 
				hs <= '1';
			end if;
			h_cnt <= h_cnt + 1;
			if (h_cnt = 800) then 
				h_cnt <= 0;
				v_cnt <= v_cnt + 1;
			end if;
		else  -- activite
			h_cnt <= h_cnt + 1;
			char_h_cnt <= char_h_cnt + 1;
			if (char_h_cnt = 8) then
				char_h_cnt <= 0;
				char_line_pos <= char_line_pos + 1;
				if (char_line_pos = 80) then
					char_line_pos <= 0;
					char_v_cnt <= char_v_cnt + 1;
					if (char_v_cnt = 16) then
						char_v_cnt <= char_v_cnt + 1;
						char_start_pos <= char_start_pos + 80;
						if (char_start_pos = 640) then
							char_start_pos <= 0;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;
end;
