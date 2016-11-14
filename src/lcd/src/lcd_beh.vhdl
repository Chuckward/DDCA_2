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
use work.lcd_controller_pkg.all;

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
	signal clk_cnt, clk_cnt_next		:	integer;
	signal busy_next						:	std_logic;
	signal lcd_busy							:	boolean;
	signal init_done						:	boolean;

	procedure isBusy (
		rs_	: out std_logic;
		rw_ 	: out std_logic;
		lcd_busy : out boolean;
		db_ 	: in std_logic_vector(7 downto 0)
		) is
	begin
		rs_ := '0';
		rw_ := '1';
		en_ : out std_logic;
		if(db_(7) = '0') then
			lcd_busy := false;
		else 
			lcd_busy := true;
		end if;
	end procedure isBusy;
	
	procedure writeCommand(
		rs : out std_logic;
		rw : out std_logic;
		en : out std_Logic;
		db : out std_logic_vector(7 downto 0)
	) is
	
	begin
	
	end procedure writeCommand;

	
begin

	next_state : process(wr, clk_cnt, instr, instr_data, lcd_state, init_done)
	begin
		lcd_state_next <= lcd_state;
		
		case lcd_state is
			when STATE_INIT =>
				if init_done = true then
					lcd_state_next <= STATE_IDLE;
				end if;
			-- TODO: depending on output behavior, most of the states come from
			when STATE_IDLE =>
				if wr = '1' then
					case instr is 
						when INSTR_SET_CHAR =>
							if instr_data(7 downto 0) = CHAR_LINEFEED or 
								instr_data(7 downto 0) = CHAR_CARRIAGE_RETURN then --new line
								lcd_state_next <= STATE_NEW_LINE;
							elsif instr_data(7 downto 0) = CHAR_BACKSPACE then 
								lcd_state_next <= STATE_DELETE;
							else
								lcd_state_next <= STATE_SET_CHAR;
							end if;
						when INSTR_CLR_SCREEN =>
							lcd_state_next <= STATE_CLR_SCREEN;
						when INSTR_SET_CURSOR_POS =>
							lcd_state_next <= STATE_SET_CURSOR_POS;
						when INSTR_CONFIG =>
							lcd_state_next <= STATE_CFG;
						when INSTR_DELETE =>
							lcd_state_next <= STATE_DELETE;
						when INSTR_MOVE_CURSOR =>
							lcd_state_next <= STATE_MOVE_CURSOR_NEXT;
						when INSTR_NEW_LINE =>
							lcd_state_next <= STATE_NEW_LINE;
						when INSTR_NOP =>
							lcd_state_next <= STATE_IDLE;
						when others =>
					end case;
				else 
					lcd_state_next <= STATE_IDLE;
				end if;
			when STATE_SET_CHAR =>
			
			when STATE_DELETE =>
			
			when STATE_CLR_SCREEN =>
				lcd_state_next <= STATE_IDLE;
			when STATE_MOVE_CURSOR_NEXT =>
			
			when STATE_NEW_LINE =>
			--	wait until db(7) = '0';
			
			when STATE_CFG =>
				lcd_state_next <= STATE_IDLE;
			when STATE_SET_CURSOR_POS =>
		
		end case;
		
	end process next_state;
	
	output : process(clk_cnt, lcd_state, lcd_state_next)
	begin
		busy_next <= '1';
		case lcd_state is
			when STATE_INIT =>					-- initialization is handled in a separate process since wait statements
				busy_next <= '0';	-- are not supported if a sensitivitiy list is used. The process terminates if init is done
			when STATE_IDLE =>
				null;						-- nothing to do
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
	
	init : process
	begin
		wait until res_n = '0';		-- halt process
		init_done <= false;
		if (clk_cnt > 375000) and (clk_cnt < 477500) then 		-- 4.1 ms
			db <= x"30";		-- 0011 0000
		else
			if (clk_cnt < 485000) then		-- 120 us
				db <= x"30";
			else
				db <= x"30";
				db <= x"3C";		-- 2 lines 5x8 font
				db <= x"0F";		-- display on
				db <= x"01";		-- display clear
				db <= x"06";		-- cursor moving right, display shift off
				init_done <= true;
				clk_cnt_next <= 0;
				
			end if;
		end if;
	end process init;
	
	sync : process(clk, res_n, clk_cnt, lcd_busy) 
	begin
		if res_n = '0' then
			lcd_state <= STATE_INIT;
			clk_cnt <= 0;
			rs <= '0';
			rw <= '0';
			en <= '0';
			
		elsif rising_edge(clk) then
			busy <= busy_next;
			lcd_state <= lcd_state_next;
			if clk_cnt_next = 0 then
				clk_cnt <= 0;
				clk_cnt_next <= 1;
			end if;
			clk_cnt <= clk_cnt + 1;
			-- TODO: It depends whether the clock of this module should be 
			-- halfed or if the busy flag should be read
		
		end if;	
	end process sync;
	
	
		
	
end architecture beh;