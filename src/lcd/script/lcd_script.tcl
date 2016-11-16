# ModelSim Script file for Behavorial Simulation Task 2
# Andreas Ciachi e1029176
# November 2016

# compile all source files
project compileoutofdate

# start simulation with "testbench"
vsim work.lcd_tb

# add signals to waveform viewer
add wave -format logic -label "clk" 		/lcd_tb/clk
add wave -format logic -label "res_n" 		/lcd_tb/reset_n
add wave -format logic -label "busy"		/lcd_tb/busy
add wave -format logic -label "en"		/lcd_tb/en
add wave -format logic -label "rw"		/lcd_tb/rw
add wave -format logic -label "rs"		/lcd_tb/rs
add wave -format logic -label "db"		/lcd_tb/db

add wave -label "LCD state"			/lcd_tb/uut/lcd_state
add wave -label "Send state"			/lcd_tb/uut/send_state
add wave -label "Init state"			/lcd_tb/uut/init_state

add wave -label "lcd busy"		/lcd_tb/uut/lcd_busy
add wave -label "send cnt"		/lcd_tb/uut/send_cnt
add wave -label "clk cnt"		/lcd_tb/uut/clk_cnt
 
# run simulation for x [time]
run 25 ms
