library ieee;
use ieee.std_logic_1164.all;

entity ps2_ascii is
	port
	(
		clk, res_n : in std_logic;
		scancode : in std_logic_vector(7 downto 0);
		new_scancode : in std_logic;

		ascii : out std_logic_vector(7 downto 0);
		new_ascii : out std_logic
	);
end entity ps2_ascii;
