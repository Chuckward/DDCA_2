------------------------------------------------------------------------------------------------
------	Quartus II RS232 Receiver package
------	for LabExercise 1.3
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package serial_port_receiver_pkg is
	component serial_port_receiver is
		generic (
			CLK_DIVISOR	:	integer
		);
		port (
			clk, res_n	:	in std_logic;
			rx				:	in std_logic;
			
			data			: out std_logic_vector(7 downto 0);
			data_new		: out std_logic
		);
	end component serial_port_receiver;
end package serial_port_receiver_pkg;

--- EOF ---