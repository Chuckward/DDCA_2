----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  output_logic_beh                                               --
-- Project Name: DIDELU                                                         --
-- Description:  Output Logic FSM - Architecture                                --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.textmode_controller_pkg.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture beh of output_logic is
  -- Number of implemented colors
  constant MAX_COLOR_INDEX : integer := 15;
  -- Color array type
  type COLOR_ARRAY is array(0 to MAX_COLOR_INDEX - 1) of std_logic_vector(3 downto 0);
  -- Array of implemented colors
  constant colors : COLOR_ARRAY :=
  (
    "1111",
    "0001",
    "0010",
    "0011",
	 "0100",
    "0101",
    "0110",
    "0111",
	 "1000",
    "1001",
    "1010",
    "1011",
	 "1100",
    "1101",
    "1110"
  );
  
  type VGA_STATE_TYPE is (STATE_RESET, STATE_INIT, STATE_WAIT_FREE,
                          STATE_IDLE, STATE_ASCII_NEW,
                          STATE_READ_NEXT_ASCII,
                          STATE_PROCESS_NEXT_ASCII, STATE_ERROR, STATE_WAIT_NOT_FREE,
                          STATE_ERROR_SET_BACKGROUND, STATE_ERROR_WAIT_NOT_FREE,
                          STATE_ERROR_WAIT_FREE, STATE_ERROR_IDLE,
                          STATE_CHANGE_COLOR, STATE_FIRST_COLOR, STATE_NEXT_COLOR,
                          STATE_CHANGE_COLOR_SET_CURSOR, STATE_CHANGE_COLOR_WAIT_NOT_FREE, 
                          STATE_CHANGE_COLOR_WAIT_FREE, STATE_CHANGE_COLOR_WAIT_BUTTON_RELEASE,
                          STATE_READ_NEXT_RS232, STATE_PROCESS_NEXT_RS232, STATE_RS232_NEW,
                          STATE_RS232_WAIT_NOT_FREE, STATE_RS232_WAIT_FREE);
  signal vga_state, vga_state_next : VGA_STATE_TYPE;
  signal textmode_instruction_next : std_logic_vector(7 downto 0);
  signal textmode_instruction_data_next : std_logic_vector(15 downto 0);
  signal textmode_wr_next : std_logic;
  signal color_index, color_index_next : integer range 0 to MAX_COLOR_INDEX - 1;
begin

  --------------------------------------------------------------------
  --                    PROCESS : NEXT_STATE                        --
  --------------------------------------------------------------------
  
  next_state: process(vga_state, textmode_busy, ascii, ascii_full, ascii_empty, color_change, color_index, rs232_full, rs232_empty, rs232_data)
  begin
    vga_state_next <= vga_state;

    case vga_state is  
      when STATE_RESET =>
        if textmode_busy = '0' then
          vga_state_next <= STATE_INIT;
        end if;
      when STATE_INIT =>
        vga_state_next <= STATE_WAIT_NOT_FREE;
      when STATE_WAIT_NOT_FREE =>      
        if textmode_busy = '1' then
          vga_state_next <= STATE_WAIT_FREE;
        end if;  
      when STATE_WAIT_FREE =>
        if textmode_busy = '0' then
          vga_state_next <= STATE_IDLE;
        end if;  
      when STATE_IDLE =>
        if ascii_full = '1' or rs232_full = '1' then
          vga_state_next <= STATE_ERROR;
        elsif color_change = '1' then
          vga_state_next <= STATE_CHANGE_COLOR;
        elsif rs232_empty = '0' then
          vga_state_next <= STATE_READ_NEXT_RS232;
        elsif ascii_empty = '0' then
          vga_state_next <= STATE_READ_NEXT_ASCII;
        end if;
      when STATE_READ_NEXT_ASCII =>
        vga_state_next <= STATE_PROCESS_NEXT_ASCII;
      when STATE_PROCESS_NEXT_ASCII =>
        vga_state_next <= STATE_ASCII_NEW;
      when STATE_ASCII_NEW =>
          vga_state_next <= STATE_WAIT_NOT_FREE;
      when STATE_READ_NEXT_RS232 =>
        vga_state_next <= STATE_PROCESS_NEXT_RS232;
      when STATE_PROCESS_NEXT_RS232 =>
        vga_state_next <= STATE_RS232_NEW;
      when STATE_RS232_NEW =>
        vga_state_next <= STATE_RS232_WAIT_NOT_FREE;
      when STATE_RS232_WAIT_NOT_FREE =>
        if textmode_busy = '1' then
          vga_state_next <= STATE_RS232_WAIT_FREE;
        end if;
      when STATE_RS232_WAIT_FREE =>
        if textmode_busy = '0' then
          vga_state_next <= STATE_IDLE; -- Do not advance cursor for CR of LF
        end if;
      when STATE_ERROR =>
        vga_state_next <= STATE_ERROR_SET_BACKGROUND;
      when STATE_ERROR_SET_BACKGROUND =>
	     vga_state_next <= STATE_ERROR_WAIT_NOT_FREE;
	   when STATE_ERROR_WAIT_NOT_FREE =>
	     if textmode_busy = '1' then
	       vga_state_next <= STATE_ERROR_WAIT_FREE;
		  end if;
	   when STATE_ERROR_WAIT_FREE =>
	     if textmode_busy = '0' then
	       vga_state_next <= STATE_ERROR_IDLE;
		  end if;
      when STATE_ERROR_IDLE =>
	     null;
	   when STATE_CHANGE_COLOR =>
	     if color_index = MAX_COLOR_INDEX - 1 then
		    vga_state_next <= STATE_FIRST_COLOR;
		  else
	       vga_state_next <= STATE_NEXT_COLOR;
		  end if;
     when STATE_FIRST_COLOR =>
	     vga_state_next <= STATE_CHANGE_COLOR_SET_CURSOR;
     when STATE_NEXT_COLOR =>
	     vga_state_next <= STATE_CHANGE_COLOR_SET_CURSOR;
     when STATE_CHANGE_COLOR_SET_CURSOR =>
       vga_state_next <= STATE_CHANGE_COLOR_WAIT_NOT_FREE;
     when STATE_CHANGE_COLOR_WAIT_NOT_FREE =>
       if textmode_busy = '1' then
	       vga_state_next <= STATE_CHANGE_COLOR_WAIT_FREE;
		   end if;
     when STATE_CHANGE_COLOR_WAIT_FREE =>
       if textmode_busy = '0' then
	       vga_state_next <= STATE_CHANGE_COLOR_WAIT_BUTTON_RELEASE;
		   end if;
	   when STATE_CHANGE_COLOR_WAIT_BUTTON_RELEASE =>
       if color_change = '0' then
	       vga_state_next <= STATE_IDLE;
       end if;
    end case;
  end process;

  --------------------------------------------------------------------
  --                    PROCESS : OUTPUT                            --
  --------------------------------------------------------------------
  
  output : process(vga_state, ascii, color_index, rs232_data)
  begin
    textmode_instruction_next <= INSTR_NOP;
    textmode_instruction_data_next <= (others => '0');
	 textmode_wr_next <= '0';
    ascii_rd <= '0';
    rs232_rd <= '0';
    color_index_next <= color_index;

    case vga_state is
      when STATE_RESET =>
        null;
      when STATE_INIT =>
        textmode_instruction_next <= INSTR_CFG;
		  textmode_instruction_data_next <= "0000" & colors(color_index) & "0000" & '0' & '0' & "10";
	     textmode_wr_next <= '1';
      when STATE_WAIT_NOT_FREE =>
        null;
      when STATE_WAIT_FREE =>
        null;
      when STATE_IDLE =>
        null;
      when STATE_READ_NEXT_ASCII =>
        ascii_rd <= '1';
      when STATE_PROCESS_NEXT_ASCII =>
        null;
      when STATE_ASCII_NEW =>
		  textmode_instruction_next <= INSTR_SET_CHAR;
		  textmode_instruction_data_next <= colors(color_index) & "0000" & ascii;
	     textmode_wr_next <= '1';
      when STATE_READ_NEXT_RS232 =>
        rs232_rd <= '1';
      when STATE_PROCESS_NEXT_RS232 =>
        null;
      when STATE_RS232_NEW =>
        textmode_instruction_next <= INSTR_SET_CHAR;
		  textmode_instruction_data_next <= colors(color_index) & "0000" & rs232_data;
	     textmode_wr_next <= '1';
      when STATE_RS232_WAIT_NOT_FREE =>
        null;
      when STATE_RS232_WAIT_FREE =>
        null;
      when STATE_ERROR =>
        null;
      when STATE_ERROR_SET_BACKGROUND =>
	     textmode_instruction_next <= INSTR_CLEAR_SCREEN;
		  textmode_instruction_data_next <= "0000" & "0100" & x"00";
	     textmode_wr_next <= '1';
	   when STATE_ERROR_WAIT_NOT_FREE =>
	     null;
	   when STATE_ERROR_WAIT_FREE =>
	     null;
      when STATE_ERROR_IDLE =>
	     null;
	   when STATE_CHANGE_COLOR =>
	     null;
     when STATE_FIRST_COLOR =>
	     color_index_next <= 0;
     when STATE_NEXT_COLOR =>
	     color_index_next <= color_index + 1;
     when STATE_CHANGE_COLOR_SET_CURSOR =>
        textmode_instruction_next <= INSTR_CFG;
		  textmode_instruction_data_next <= "0000" & colors(color_index) & "0000" & '0' & '0' & "10";
	     textmode_wr_next <= '1';
     when STATE_CHANGE_COLOR_WAIT_NOT_FREE =>
       null;
     when STATE_CHANGE_COLOR_WAIT_FREE =>
       null;
	   when STATE_CHANGE_COLOR_WAIT_BUTTON_RELEASE =>
	     null;
    end case;
  end process;

  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  -------------------------------------------------------------------- 
  
  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      vga_state <= STATE_RESET;
      textmode_instruction <= INSTR_NOP;
		textmode_instruction_data <= (others => '0');
	   textmode_wr <= '0';
	   color_index <= 0;
    elsif rising_edge(clk) then
      vga_state <= vga_state_next;
      textmode_instruction <= textmode_instruction_next;
		textmode_instruction_data <= textmode_instruction_data_next;
	   textmode_wr <= textmode_wr_next;
	   color_index <= color_index_next;
    end if;
  end process;
end architecture beh;

--- EOF ---
