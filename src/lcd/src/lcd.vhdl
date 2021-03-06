------------------------------------------------------------------------------------------------
------	Quartus II LCD entity
------	for LabExercise 2.1
------	
------	Author Andreas Ciachi
------	e1029176
------	November 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lcd_controller is 
	generic (
		CLK_FREQ	:	integer
	);
	port (
		clk			:	in std_logic;
		res_n			:	in std_logic;
		wr				:	in std_logic;
		instr			:	in std_logic_vector(7 downto 0);
		instr_data	:	in std_logic_vector(15 downto 0);
		
		busy			:	out std_logic;
		rs				:	out std_logic;
		rw				:	out std_logic;
		db				:	inout std_logic_vector(7 downto 0);
		en				:	out std_logic
	);
end entity lcd_controller;
