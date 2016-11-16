------------------------------------------------------------------------------------------------
------	Quartus II Serial Port Testbench 
------	for Exercise 2 Task 4
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd_tb is
end lcd_tb;

architecture beh of lcd_tb is 
	component lcd_controller is
		generic (
		CLK_FREQ	:	integer
		);
		port (
			clk			:	in std_logic;
			res_n		:	in std_logic;
			wr			:	in std_logic;
			instr		:	in std_logic_vector(7 downto 0);
			instr_data	:	in std_logic_vector(15 downto 0);
			
			busy		:	out std_logic;
			rs			:	out std_logic;
			rw			:	out std_logic;
			db			:	inout std_logic_vector(7 downto 0);
			en			:	out std_logic
		);
	end component;
	
	constant CLK_FREQ	:	integer 		:= 25000000;
	constant CLK_PERIOD	:	time			:= 40 ns;
	
	signal clk, reset_n	: 	std_logic;
	signal rx, wr		: 	std_logic;
	signal instr		: 	std_logic_vector(7 downto 0);
	signal instr_data	: 	std_logic_vector(15 downto 0);
	signal db		:	std_logic_vector(7 downto 0);
	signal busy, rs		:	std_logic;
	signal rw, en		: 	std_logic;
	
begin
uut: lcd_controller
	generic map(CLK_FREQ)
	port map(clk, reset_n, wr, instr, instr_data, busy, rs, rw, db, en);
		
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
		--	wait for 10 us;
		--	wait until rising_edge(clk);
		--	rx <= '0';						-- start bit
								-- stop bit
		end procedure;
	begin
		report "Sending data now";
		rx <= '1';
		wait until rising_edge(reset_n);
		--wait for 150 us;
		--send_data(x"AB");	-- AB 1010 1011
		--wait for 150 us;
		--send_data(x"CD");	-- CD 1100 1101
		--wait for 150 us;
		--send_data(x"EF");	-- EF 1110 1111*/
	end process input;		
end architecture beh;