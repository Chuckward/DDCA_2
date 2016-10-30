----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  rom_synch_1r_beh                                               --
-- Project Name: DIDELU                                                         --
-- Description:  ROM - Architecture                                             --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rom_pkg.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture beh of rom_sync_1r is
  constant rom : rom_array(0 to 2 ** ADDR_WIDTH - 1, DATA_WIDTH - 1 downto 0) := INIT_PATTERN;
begin

  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  --------------------------------------------------------------------
  
  sync : process(clk)
  begin
    if rising_edge(clk) then
      if rd = '1' then
        data <= to_stdlogicvector(rom, to_integer(unsigned(addr)));
      end if;
    end if;
  end process sync;
  
end architecture beh;

--- EOF ---