# ModelSim Script file for Behavorial Simulation Task 1
# Andreas Ciachi e1029176
# October 2016

# compile all source files
project compileoutofdate

# start simulation with "testbench"
vsim work.rs232_tb

# add signals to waveform viewer
add wave -format logic -label "clk" 		/rs232_tb/clk
add wave -format logic -label "res_n" 		/rs232_tb/reset_n
add wave -format logic -label "rx"		/rs232_tb/rx
add wave -radix hexadecimal -label "data"	/rs232_tb/data
add wave -format logic -label "new data"	/rs232_tb/data_new
add wave -format logic -label "state"		/rs232_tb/uut/receiver_state
 
# run simulation for x [time]
run 3500 us