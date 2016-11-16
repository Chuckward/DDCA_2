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
	
	type INIT_STATE_TYPE is (
		STATE_INIT_0,
		STATE_INIT_1,
		STATE_INIT_2,
		STATE_INIT_3,
		STATE_INIT_4,
		STATE_INIT_5,
		STATE_INIT_6,
		STATE_INIT_7
	);	
	
	type SEND_STATE_TYPE is (
		STATE_SEND_CMD,
		STATE_SEND_DATA,
		STATE_SEND_IDLE
	);	
	
	signal lcd_state, lcd_state_next		: LCD_STATE_TYPE;
	signal init_state, init_state_next 	: INIT_STATE_TYPE;
	signal send_state, send_state_next	: SEND_STATE_TYPE;
	signal clk_cnt, clk_cnt_next			: integer;
	signal send_cnt, send_cnt_next		: integer;
	signal busy_next							: std_logic;
	signal lcd_busy, lcd_busy_next		: boolean;
	signal rs_next, rw_next, en_next 	: std_logic;
	signal rs_cmd, rw_cmd					: std_logic;
	signal db_next, db_data, db_data_next	: std_logic_vector(7 downto 0);

begin

	next_state : process(clk, clk_cnt, send_cnt, wr, instr, instr_data, lcd_state, send_state, init_state, lcd_busy)
	begin
		lcd_state_next <= lcd_state;
		init_state_next <= init_state;
		send_cnt_next <= send_cnt;
		send_state_next <= send_state;
		lcd_busy_next <= lcd_busy;

		case send_state is
			when STATE_SEND_IDLE =>
				rs_next <= '0';
				rw_next <= '0';
				en_next <= '0';
				db_next <= x"00";
				lcd_busy_next <= false;
				rs_cmd <= '0';
				rw_cmd <= '0';
			when STATE_SEND_CMD =>
				lcd_busy_next <= true;
				rs_next <= rs_cmd;
				rw_next <= rw_cmd;
				send_cnt_next <= 0;
				send_state_next <= STATE_SEND_DATA;
			when STATE_SEND_DATA =>
				db_next <= db_data;
				en_next <= '1';
				send_cnt_next <= send_cnt + 1;
				if (send_cnt > 14) then		-- send tcyce > 500 ns (14x40ns = 560ns)
					send_state_next <= STATE_SEND_IDLE;
				end if;
		end case;
		
		
		case lcd_state is
			when STATE_INIT =>
				case init_state is
					when STATE_INIT_0 =>
						if clk_cnt > 375000 then
							init_state_next <= STATE_INIT_1;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_1 =>
						if clk_cnt > 477500 then
							init_state_next <= STATE_INIT_2;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_2 =>
						if clk_cnt > 480500 then
							init_state_next <= STATE_INIT_3;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_3 =>
						if(lcd_busy = false) then
							init_state_next <= STATE_INIT_4;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_4 =>
						if(lcd_busy = false) then
							init_state_next <= STATE_INIT_5;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_5 =>
						if(lcd_busy = false) then
							init_state_next <= STATE_INIT_6;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_6 =>
						if(lcd_busy = false) then
							init_state_next <= STATE_INIT_7;
							send_state_next <= STATE_SEND_CMD;
						end if;
					when STATE_INIT_7 =>
						if(lcd_busy = false) then
							init_state_next <= STATE_INIT_0;
							send_state_next <= STATE_SEND_CMD;
							lcd_state_next <= STATE_IDLE;
						end if;						
				end case;
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
							init_state_next <= STATE_INIT_0;
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
	
	output : process(clk, send_cnt, lcd_state, send_state, init_state, rs_cmd, rw_cmd, db_data, lcd_busy)
	begin
		db_data_next <= db_data;
		busy_next <= '1';
		
		case lcd_state is
			when STATE_INIT =>		
				if lcd_busy = false then	
					case init_state is
						when STATE_INIT_0 =>
							db_data_next <= x"00";
						when STATE_INIT_1 =>
							db_data_next <= x"30";
						when STATE_INIT_2 =>
							db_data_next <= x"30";
						when STATE_INIT_3 =>
							db_data_next <= x"30";
						when STATE_INIT_4 =>
							db_data_next <= x"3C";
						when STATE_INIT_5 =>
							db_data_next <= x"0F";
						when STATE_INIT_6 =>
							db_data_next <= x"01";
						when STATE_INIT_7 =>
							db_data_next <= x"06";
					end case;
				end if;
				
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
	end process output;
	
	sync : process(clk, res_n, db_next) 
	begin
		if res_n = '0' then
			lcd_state <= STATE_INIT;
			send_state <= STATE_SEND_IDLE;
			init_state <= STATE_INIT_0;
			clk_cnt <= 0;
			send_cnt <= 0;
			busy <= '0';
			en <= '0';
			
		elsif rising_edge(clk) then
			busy <= busy_next;
			rs <= rs_next;
			rw <= rw_next;
			en <= en_next;
			db <= db_next;
			send_cnt <= send_cnt_next;
			db_data <= db_data_next;
			lcd_busy <= lcd_busy_next;
			init_state <= init_state_next;
			send_state <= send_state_next;
			lcd_state <= lcd_state_next;
			if (clk_cnt < 490000) then
				clk_cnt <= clk_cnt + 1;
			end if;
		end if;	
	end process sync;
end architecture beh;