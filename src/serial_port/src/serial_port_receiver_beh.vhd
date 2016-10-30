------------------------------------------------------------------------------------------------
------	Quartus II RS232 Receiver File
------	for LabExercise 1.3
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture beh of serial_port_receiver is
	type RECEIVER_STATE_TYPE is (
		STATE_IDLE,
		STATE_WAIT_START_BIT,
		STATE_MIDDLE_OF_START_BIT,
		STATE_GOTO_MIDDLE_OF_START_BIT,
		STATE_WAIT_DATA_BIT,
		STATE_MIDDLE_OF_DATA_BIT,
		STATE_WAIT_STOP_BIT,
		STATE_MIDDLE_OF_STOP_BIT
		);
	
	signal receiver_state, receiver_state_next	:	RECEIVER_STATE_TYPE;
	signal bit_cnt, bit_cnt_next						:	integer range 0 to 8;
	signal clk_cnt, clk_cnt_next						:	integer range 0 to CLK_DIVISOR - 1;
	signal rx_next, data_new_next						:	std_logic;
	signal receive_data, receive_data_next			:	std_logic_vector(7 downto 0);
begin
	
	receiver_next_stage : process(receiver_state, clk_cnt, bit_cnt, rx)
	begin 
		receiver_state_next <= receiver_state;

		case receiver_state is
			when STATE_IDLE =>
				if rx = '1' then
					receiver_state_next <= STATE_WAIT_START_BIT;
				end if;
			when STATE_WAIT_START_BIT =>
				if rx = '0' then
					receiver_state_next <= STATE_GOTO_MIDDLE_OF_START_BIT;
				end if;
			when STATE_GOTO_MIDDLE_OF_START_BIT =>
			  if clk_cnt = CLK_DIVISOR/2 - 2 then
				 receiver_state_next <= STATE_MIDDLE_OF_START_BIT;
			  end if;
			when STATE_MIDDLE_OF_START_BIT =>
				receiver_state_next <= STATE_WAIT_DATA_BIT;      
			when STATE_WAIT_DATA_BIT =>
				if clk_cnt = CLK_DIVISOR - 2 then
					receiver_state_next <= STATE_MIDDLE_OF_DATA_BIT;
				end if;
			when STATE_MIDDLE_OF_DATA_BIT =>
				if bit_cnt < 7 then
					receiver_state_next <= STATE_WAIT_DATA_BIT;
				elsif bit_cnt >= 7 then
					receiver_state_next <= STATE_WAIT_STOP_BIT;
				end if;
			when STATE_WAIT_STOP_BIT =>
				if clk_cnt = CLK_DIVISOR - 2 then
					receiver_state_next <= STATE_MIDDLE_OF_STOP_BIT;
				end if;
			when STATE_MIDDLE_OF_STOP_BIT =>
				if rx = '0' then
					receiver_state_next <= STATE_IDLE;
				elsif rx = '1' then
					receiver_state_next <= STATE_WAIT_START_BIT;
				end if;
		 end case;
	end process receiver_next_stage;
	
	receiver_output : process(receiver_state, clk_cnt, bit_cnt, rx, receive_data)
	begin
		clk_cnt_next <= clk_cnt;
		bit_cnt_next <= bit_cnt;
		data_new_next <= '0';
		
		case receiver_state is
			when STATE_IDLE =>
				null;
			when STATE_WAIT_START_BIT =>
				clk_cnt_next <= 0;
				bit_cnt_next <= 0;
			when STATE_GOTO_MIDDLE_OF_START_BIT =>
				clk_cnt_next <= clk_cnt + 1;
			when STATE_MIDDLE_OF_START_BIT =>
				clk_cnt_next <= 0;
			when STATE_WAIT_DATA_BIT =>
				clk_cnt_next <= clk_cnt + 1;
			when STATE_MIDDLE_OF_DATA_BIT =>
				receive_data_next <= rx & receive_data(7 downto 1);
				bit_cnt_next <= bit_cnt + 1;
				clk_cnt_next <= 0;
			when STATE_WAIT_STOP_BIT =>
				data_new_next <= '1';		
				clk_cnt_next <= clk_cnt + 1;
			when STATE_MIDDLE_OF_STOP_BIT =>
				clk_cnt_next <= 0;
				data_new_next <= '0';
		end case;	
	end process receiver_output;
	
	sync : process(clk, res_n)
	begin
		if res_n = '0' then
			receiver_state <= STATE_IDLE;
			clk_cnt <= 0;
			bit_cnt <= 0;
			data <= x"00";
		elsif rising_edge(clk) then
			receiver_state <= receiver_state_next;
			receive_data <= receive_data_next;
			clk_cnt <= clk_cnt_next;
			bit_cnt <= bit_cnt_next;
			data <= receive_data;
			data_new <= data_new_next;
		
		end if;
	end process sync;
end architecture beh;