library ieee;
use ieee.std_logic_1164.all;

entity startup is port(
	reset_CPU: out std_logic;
	address: out 