------------------------------------------------------------------------------------------------
------	Quartus II LCD package
------	for LabExercise 2.1
------	
------	Author Andreas Ciachi
------	e1029176
------	November 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package lcd_controller_pkg is

	constant INSTR_NOP 				: std_logic_vector(7 downto 0) := (others=>'0');
	constant INSTR_SET_CHAR 		: std_logic_vector(7 downto 0) := x"01";
	constant INSTR_CLR_SCREEN 		: std_logic_vector(7 downto 0) := x"02";
	constant INSTR_SET_CURSOR_POS : std_logic_vector(7 downto 0) := x"03";
	constant INSTR_CONFIG			: std_logic_vector(7 downto 0) := x"04";
	constant INSTR_DELETE 			: std_logic_vector(7 downto 0) := x"05";
	constant INSTR_MOVE_CURSOR 	: std_logic_vector(7 downto 0) := x"06";
	constant INSTR_NEW_LINE 		: std_logic_vector(7 downto 0) := x"07";
	
	constant CHAR_LINEFEED 			: std_logic_vector(7 downto 0) := x"0A";
	constant CHAR_BACKSPACE 		: std_logic_vector(7 downto 0) := x"08";
	constant CHAR_CARRIAGE_RETURN : std_logic_vector(7 downto 0) := x"0D";
	
	component lcd_controller is
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
			db				:	out std_logic_vector(7 downto 0);
			en				:	out std_logic
		);
	end component lcd_controller;
end package lcd_controller_pkg;

package body lcd_controller_pkg is 
	
end lcd_controller_pkg;

--- EOF ---