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
use work.lcd_pkg.all;

architecture beh of lcd_controller is
	type LCD_STATE_TYPE is (
		STATE_INIT,
		STATE_IDLE,
		STATE_SET_CHAR,
		STATE_DELETE,
		STATE_CLR_SCREEN,
		STATE_MOVE_CURSOR_NEXT,
		STATE_NEW_LINE,
		STATE_CFG,
		STATE_SET_CURSOR_POS
	);
	
	signal lcd_state, lcd_state_next	:	LCD_STATE_TYPE;
	signal clk_cnt, clk_cnt_next		:	integer range 0 to 1;
	signal lcd_busy						:	boolean;
	
begin

	next_state : process(clk_cnt, instr)
	begin
		lcd_state <= lcd_state_next;
		lcd_busy <= true;
		
		case lcd_state is
			when STATE_INIT =>
				null;
			-- TODO: depending on output behavior, most of the states come from
			when STATE_IDLE =>
				if instr(1 downto 0) = INSTR_SET_CHAR then
					lcd_state_next <= STATE_SET_CHAR;
				elsif instr = INSTR_CLR_SCREEN then
					lcd_state_next <= STATE_CLR_SCREEN;
				elsif instr = INSTR_SET_CURSOR_POS then
					lcd_state_next <= STATE_SET_CURSOR_POS;
				elsif instr = INSTR_CONFIG then
					lcd_state_next <= STATE_CFG;
				elsif instr = INSTR_DELETE then
					lcd_state_next <= STATE_DELETE;
				elsif instr = INSTR_MOVE_CURSOR then
					lcd_state_next <= STATE_MOVE_CURSOR_NEXT;
				elsif instr = INSTR_NEW_LINE then
					lcd_state_next <= STATE_NEW_LINE;
				else 
					lcd_state_next <= STATE_IDLE;
					lcd_state <= false;
				end if;
			when STATE_SET_CHAR =>
			
			when STATE_DELETE =>
			
			when STATE_CLR_SCREEN =>
			
			when STATE_MOVE_CURSOR_NEXT =>
			
			when STATE_NEW_LINE =>
			
			when STATE_CFG =>
			
			when STATE_SET_CURSOR_POS =>
		
		end case;
		
	end process next_state;
	
	output : process(clk_cnt, lcd_state_next)
	begin
		lcd_state <= lcd_state_next;
		
		case lcd_state is
			when STATE_INIT =>
				-- TODO: Here comes the initialization sequence for the LCD 
			when STATE_IDLE =>
			
			when STATE_SET_CHAR =>
			
			when STATE_DELETE =>
			
			when STATE_CLR_SCREEN =>
			
			when STATE_MOVE_CURSOR_NEXT =>
			
			when STATE_NEW_LINE =>
			
			when STATE_CFG =>
			
			when STATE_SET_CURSOR_POS =>
			
			
		end case;
		-- TODO: set RS, RW, DB and EN depending on input
	end process output;
	
	sync : process(clk_cnt) 
	begin
		if res_n = '0' then
			lcd_state <= STATE_INIT;
			
			
		elsif rising_edge(clk) then
			-- TODO: It depends whether the clock of this module should be 
			-- halfed or if the busy flag should be read
		
		end if;	
	end process sync;
end architecture beh;