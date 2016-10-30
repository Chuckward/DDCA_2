------------------------------------------------------------------------------------------------
------	Quartus II RS232 RS232 package
------	for LabExercise 1.3
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package rs232_controller_pkg is
	component rs232_controller is
		generic (
			CLK_FREQ			:	integer;
			BAUD_RATE		:	integer;
			SYNC_STAGES		:	integer;
			RX_FIFO_DEPTH	:	integer;
			TX_FIFO_DEPTH	:	integer
		);
		port (
			clk, res_n		:	in std_logic;
			rx					:	in std_logic;
			rx_rd				:	in std_logic;
			tx_data			:	in std_logic_vector(7 downto 0);
			tx_wr				:	in std_logic;
			
			rx_data			: out std_logic_vector(7 downto 0);
			rx_data_empty	: out std_logic;
			rx_Data_full	: out std_logic;
			tx					: out std_logic;
			tx_free			: out std_logic
		);
	end component rs232_controller;
end package rs232_controller_pkg;

--- EOF ---