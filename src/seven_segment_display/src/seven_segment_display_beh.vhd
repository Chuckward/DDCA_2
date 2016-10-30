----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  23.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  seven_segment_display_beh                                      --
-- Project Name: DIDELU                                                         --
-- Description:  Seven segment display - Architecture                           --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture beh of seven_segment_display is
  -- modify character into bit-strings to drive segments
  function to_segs(value : in std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
    case value is
      when x"0" => return "1000000";
      when x"1" => return "1111001";
      when x"2" => return "0100100";
      when x"3" => return "0110000";
      when x"4" => return "0011001";
      when x"5" => return "0010010";
      when x"6" => return "0000010";
      when x"7" => return "1111000";
      when x"8" => return "0000000";
      when x"9" => return "0010000";
      when x"A" => return "0001000";
      when x"B" => return "0000011";
      when x"C" => return "1000110";
      when x"D" => return "0100001";
      when x"E" => return "0000110";
      when x"F" => return "0001110";
      when others => return "1111111";
    end case;
  end function;

  signal data_int : std_logic_vector(4 * DISPLAY_COUNT - 1 downto 0);
begin
  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  --------------------------------------------------------------------

  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      data_int <= (others => '0');
    elsif rising_edge(clk) then
      if new_data = '1' then
        data_int <= data;
      end if;
    end if;
  end process sync;

  display_gen : for i in 0 to DISPLAY_COUNT - 1 generate
    seg_data(7 * (i + 1) - 1 downto 7 * i) <= to_segs(data_int(4 * (i + 1) - 1 downto 4 * i));
  end generate display_gen;
end architecture beh;

--- EOF ---