------------------------------------------------------------------------------------------------
------	Quartus II RS232 Transmitter package
------	for LabExercise 1.3
------	
------	Author Andreas Ciachi
------	e1029176
------	October 2016
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package serial_port_transmitter_pkg is
	component serial_port_transmitter is
		generic (
			CLK_DIVISOR	:	integer
		);
		port (
			clk, res_n	:	in std_logic;
			data			:	in std_logic_vector(7 downto 0);
			empty			:	in std_logic;

			tx				: out std_logic;
			rd				: out std_logic
		);
	end component serial_port_transmitter;
end package serial_port_transmitter_pkg;

--- EOF ---