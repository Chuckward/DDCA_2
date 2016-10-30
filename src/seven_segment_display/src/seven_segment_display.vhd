----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  23.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  seven_segment_display                                          --
-- Project Name: DIDELU                                                         --
-- Description:  Seven segment display - Entity                                 --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

-- module for driving seven segment display - converts a parallel signal vector to its seven segment representation
entity seven_segment_display is
  generic
  (
    -- clock frequency [Hz]
    CLK_FREQ      : integer;
    -- number of digits
    DISPLAY_COUNT : integer
  );
  port
  (
    clk       : in std_logic;
    res_n     : in std_logic;
    
    data      : in std_logic_vector(4 * DISPLAY_COUNT - 1 downto 0);
    new_data  : in std_logic;

    seg_data  : out std_logic_vector(7 * DISPLAY_COUNT - 1 downto 0)
  );
end entity seven_segment_display;

--- EOF ---
