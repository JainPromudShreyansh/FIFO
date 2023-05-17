#TCL code for running synchronous FIFO design and Test Bench
vlog tb_scynfifo.v
vsim tb
add wave -position insertpoint sim:/dut/*
run -all

