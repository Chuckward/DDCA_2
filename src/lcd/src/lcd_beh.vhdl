------------------------------------------------------------------------------------------------
------	Quartus II LCD behavorial file
------	for LabExercise 2.1
------	
------	Author Andreas Ciachi
------	e1029176
------	November 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture beh of lcd_controller is
	type LCD_STATE_TYPE is (
		STATE_INIT,
		STATE_IDLE,
		STATE_WAIT_START_BIT,
		STATE_MIDDLE_OF_START_BIT,
		STATE_GOTO_MIDDLE_OF_START_BIT,
		STATE_WAIT_DATA_BIT,
		STATE_MIDDLE_OF_DATA_BIT,
		STATE_WAIT_STOP_BIT,
		STATE_MIDDLE_OF_STOP_BIT
	);
	
	signal lcd_state, lcd_state_next	:	LCD_STATE_TYPE;
	signal clk_cnt, clk_cnt_next		:	integer range 0 to 1;
	
begin

	next_state : process(clk_cnt)
	begin
		-- TODO: depending on output behavior, most of the states come from
		-- the input expected from the output controller (instr and instr_data)
	end process next_state;
	
	output : process(clk_cnt)
	begin
		case lcd_state is
			when STATE_INIT
				-- TODO: Here comes the initialization sequence for the LCD 
		end case;
		-- TODO: set RS, RW, DB and EN depending on input
	end process output;
	
	sync : process(clk_cnt) 
	begin
		if res_n = '0' then
			receiver_state <= STATE_INIT;
			
			
		elsif rising_edge(clk) then
			-- TODO: It depends whether the clock of this module should be 
			-- halfed or if the busy flag should be read
		
		end if;	
	end process sync;
end architecture beh;