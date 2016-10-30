------------------------------------------------------------------------------------------------
------	Quartus II Serial Port Testbench 
------	for Exercise 1 Task 3
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rs232_tb is
end rs232_tb;

architecture beh of rs232_tb is 
	component serial_port_receiver is
		generic (
			CLK_DIVISOR : integer
		);
		port (
			clk		:	in	std_logic;
			res_n		:	in	std_logic;
			rx			:	in	std_logic;
			
			data		:	out	std_logic_vector(7 downto 0);		
			data_new	:	out	std_logic
		);
	end component;
	
	constant CLK_PERIOD	:	time 		:= 40 ns;		-- 25MHz
	constant CLK_DIVISOR	:	integer 	:= 10;
	
	signal clk, reset_n	: std_logic;
	signal rx				: std_logic;
	signal data				: std_logic_vector(7 downto 0);
	signal data_new		: std_logic;
	
begin
uut: serial_port_receiver
	generic map(2604)	 									-- 25 MHz/9600 Baud
	port map(clk, reset_n, rx, data, data_new);
		
	clkgen : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process clkgen;
	
	reset : process
	begin
		reset_n <= '0';
		wait for 10 us;
		reset_n <= '1';
		wait;
	end process reset;
	
	input : process
		procedure send_data(code : std_logic_vector(7 downto 0)) is		
		begin
			wait for 10 us;
			wait until rising_edge(clk);
			rx <= '0';						-- start bit
			wait for 104160 ns;			-- 10,416 us
			wait until rising_edge(clk);
			rx <= code(0);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(1);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(2);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(3);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(4);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(5);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(6);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= code(7);
			wait for 104160 ns;
			wait until rising_edge(clk);
			rx <= '1';						-- stop bit
		end procedure;
	begin
		report "Sending data now";
		rx <= '1';
		wait until rising_edge(reset_n);
		wait for 150 us;
		send_data(x"AB");	-- AB 1010 1011
		wait for 150 us;
		send_data(x"CD");	-- CD 1100 1101
		wait for 150 us;
		send_data(x"EF");	-- EF 1110 1111
	end process input;		
end architecture beh;