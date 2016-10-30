----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  output_logic                                                   --
-- Project Name: DIDELU                                                         --
-- Description:  Output Logic - Entity                                          --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

-- Implements the functionality of the DIDELU 2010 lab project
entity output_logic is
  port
  (
    clk   : in  std_logic;
    res_n : in  std_logic;

    -- Keypad FIFO interface
    ascii             : in  std_logic_vector(7 downto 0);
    ascii_rd          : out std_logic;
    ascii_full        : in  std_logic;
    ascii_empty       : in  std_logic;
	  
    -- RS-232 FIFO interface
    rs232_data        : in  std_logic_vector(7 downto 0);
    rs232_rd          : out std_logic;
    rs232_full        : in  std_logic;
    rs232_empty       : in  std_logic;
    
    -- Color change button interface
	  color_change      : in  std_logic;

    -- VGA controller interface
    textmode_instruction : out std_logic_vector(7 downto 0);
    textmode_instruction_data : out std_logic_vector(15 downto 0);
    textmode_busy : in std_logic;
    textmode_wr : out std_logic
  );
end entity output_logic;

