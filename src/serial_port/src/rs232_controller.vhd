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

library altera_mf;
use altera_mf.all;

entity rs232_controller is

	generic (
		CLK_FREQ			:	integer;
		BAUD_RATE		:	integer;
		SYNC_STAGES		:	integer;
		RX_FIFO_DEPTH	:	integer;
		TX_FIFO_DEPTH	:	integer
	);
	port (
		clk, res_n		:	in		std_logic;
		rx					:	in		std_logic;
		rx_rd				:	in		std_logic;
		tx_data			:	in		std_logic_vector(7 downto 0);
		tx_wr				:	in		std_logic;
		
		rx_data			:	out	std_logic_vector(7 downto 0);
		rx_data_empty	:	out	std_logic;
		rx_data_full	:	out	std_logic;
		tx					:	out	std_logic;
		tx_free			:	out	std_logic
		
	);
end entity rs232_controller;

architecture DEFAULT of rs232_controller is

	constant DATA_WIDTH	:	integer := 8;
	constant RESET_VALUE	:	std_logic := '1';
	constant CLK_DIVISOR	:	integer := CLK_FREQ/BAUD_RATE;
	
	signal sys_clk			: std_logic;
	signal rx_sync			: std_logic;
	signal rx_data_rcv	: std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal rx_data_new	: std_logic;
	signal tx_fifo_out	: std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal tx_fifo_empty	: std_logic;
	signal tx_fifo_full	: std_logic;
	signal tx_rd			: std_logic;
	
	use work.sync_pkg.all;
	use work.ram_pkg.all;
	use work.serial_port_receiver_pkg.all;
	use work.serial_port_transmitter_pkg.all;
	
begin

	sys_clk <= clk;
	tx_free <= not tx_fifo_full;

	sync_rx:sync
		generic map(SYNC_STAGES, RESET_VALUE)
		port map(sys_clk, res_n, rx, rx_sync);
	
	serial_port_receiver_fsm:serial_port_receiver
		generic map(CLK_DIVISOR)
		port map(sys_clk, res_n, rx_sync, rx_data_rcv, rx_data_new);
	
	fifo_rx:fifo_1c1r1w
		generic map(RX_FIFO_DEPTH, DATA_WIDTH)
		port map(sys_clk, res_n, rx_data, rx_rd, rx_data_rcv, rx_data_new, rx_data_empty, rx_data_full);
	
	fifo_tx:fifo_1c1r1w
		generic map(TX_FIFO_DEPTH, DATA_WIDTH)
		port map(sys_clk, res_n, tx_fifo_out, tx_rd, tx_data, tx_wr, tx_fifo_empty, tx_fifo_full);
	
	serial_port_transmitter_fsm:serial_port_transmitter
		generic map(CLK_DIVISOR)
		port map(sys_clk, res_n, tx_fifo_out, tx_fifo_empty, tx, tx_rd);

end architecture DEFAULT;

--- EOF ---