library ieee;
use ieee.std_logic_1164.all;

entity ram_selecter is port(
	from_init: in std_logic;
	addr_bridge, addr_init: in std_logic_vector(14 downto 0);
	CSN_bridge, CSN_init: in std_logic;
	WEN_bridge, WEN_init: in std_logic;
	OEN_bridge, OEN_init: in std_logic;
	data_bridge, data_init: in std_logic_vector(7 downto 0);
	addr: out std_logic_vector(14 downto 0);
	CSN: out std_logic;
	WEN: out std_logic;
	OEN: out std_logic;
	data: out std_logic_vector(7 downto 0)
	);
end ram_selecter;

architecture ram_selecter_arch of ram_selecter is begin
addr <= addr_bridge when from_init = '0' else addr_init;
CSN <= CSN_bridge when from_init = '0' else CSN_init;
WEN <= WEN_bridge when from_init = '0' else WEN_init;
OEN <= OEN_bridge when from_init = '0' else OEN_init;
data <= data_bridge when from_init = '0' else data_init;

end ram_selecter_arch;