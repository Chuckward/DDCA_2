library ieee;
use ieee.std_logic_1164.all;
use work.testbench_util_pkg.all;

entity testbench is
end testbench;

architecture beh of testbench is

  constant CLK_PERIOD : time := 20 ns;

  signal clk, reset_n      : std_logic;
  signal ps2_keyboard_clk  : std_logic;
  signal ps2_keyboard_data : std_logic;

begin
	MAIN: entity work.main
	port map(clk=>clk,
				res_n=>reset_n, 
				color_change=>'1', 
				ps2_keyboard_clk=>ps2_keyboard_clk, 
				ps2_keyboard_data=>ps2_keyboard_data, 
				rs232_rx=>'0'
	);
  
  -- Generates the clock signal
  clkgen : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process clkgen;

  -- Generates the reset signal
  reset : process
  begin  -- process reset
    reset_n <= '0';
    wait_cycle(clk, 10);
    reset_n <= '1';
    wait;
  end process;

  -- Generates the communication on the PS2 interface
  input : process
    variable temprx : std_logic_vector(7 downto 0);
  begin  -- process input
    ps2_keyboard_clk  <= 'H';
    ps2_keyboard_data <= 'H';
    wait until rising_edge(reset_n);
    wait for 50 us;

    -- init
    wait until rising_edge(ps2_keyboard_clk);
    wait for 10 us;
    report "[PS2]  Starting..." severity note;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "HHHHHHHHHH0", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H0HHHHHHH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H0H0H0HHH", temprx);
    wait until rising_edge(ps2_keyboard_clk);
    wait for 10 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "HHHHHHHHHH0", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H0HHHHHHH", temprx);
    wait until rising_edge(ps2_keyboard_clk);
    wait for 10 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "HHHHHHHHHH0", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H0HHHHHHH", temprx);
    wait until rising_edge(ps2_keyboard_clk);
    wait for 10 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "HHHHHHHHHH0", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H0HHHHHHH", temprx);

    -- send 'A'
    wait for 100 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "000HHH000HH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00000HHHHHH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "000HHH000HH", temprx);

    -- send 'B'
    wait for 100 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H00HH00HH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00000HHHHHH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00H00HH00HH", temprx);

    -- send 'C'
    wait for 100 us;
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "0H0000H00HH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "00000HHHHHH", temprx);
    sendreceive(ps2_keyboard_clk, ps2_keyboard_data, "0H0000H00HH", temprx);
    wait;
  end process;

end beh;
