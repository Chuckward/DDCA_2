# ModelSim Script file for Behavorial Simulation Task 2
# Andreas Ciachi e1029176
# October 2016

#compile all modified src files
project compileoutofdate

#start simulation with testbench
vsim -t 1ps work.testbench

#changing simulation granularity from -t 1ps (Default) to higher values is
#only possible if a pll is NOT simulated. Otherwise it MUST be 1ps 

#waveform signals
add wave -format logic -label "clk"			/testbench/MAIN/sys_clk
add wave -format logic -label "reset"		/testbench/MAIN/res_n

add wave -format logic -label "ascii new" 	/testbench/MAIN/ps2_ascii_inst/new_ascii
add wave -format ascii -label "ascii"		/testbench/MAIN/ps2_ascii_inst/ascii
add wave -format logic -label "ascii empty"	/testbench/MAIN/output_logic_inst/ascii_empty
add wave -format logic -label "ascii full"	/testbench/MAIN/output_logic_inst/ascii_full
add wave -format logic -label "ascii rd"	/testbench/MAIN/output_logic_inst/ascii_rd

add wave -format logic -label "ps2 data"	/testbench/MAIN/ps2_keyboard_controller_inst/ps2_data
add wave -format logic -label "ps2 clk"		/testbench/MAIN/ps2_keyboard_controller_inst/ps2_clk
add wave -format logic -label "ps2 scan"	/testbench/MAIN/ps2_scan

add wave -format logic -label "7 seg data"	/testbench/MAIN/seg_data

add wave -format logic -label "textm wr"		/testbench/MAIN/textmode_wr
add wave -format logic -label "textm instr"		/testbench/MAIN/textmode_instruction
add wave -format logic -label "textm instr data" 	/testbench/MAIN/textmode_instruction_data
add wave -format logic -label "textm busy"		/testbench/MAIN/textmode_busy

add wave -format logic -label "vsync"		/testbench/MAIN/vsync_n

add wave -format logic -label "RS232 tx"	/testbench/MAIN/rs232_tx


#run simulation
run 22700 us
