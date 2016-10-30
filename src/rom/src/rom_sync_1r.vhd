----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  rom_synch_1r                                                   --
-- Project Name: DIDELU                                                         --
-- Description:  ROM - Entity                                                   --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.rom_pkg.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

-- Read only memory
entity rom_sync_1r is
  generic
  (
    ADDR_WIDTH   : integer;
    DATA_WIDTH   : integer;
    INIT_PATTERN : rom_array
  );
  port
  (
    clk  : in  std_logic;
    addr : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
    rd   : in  std_logic;
    data : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity rom_sync_1r;

--- EOF ---