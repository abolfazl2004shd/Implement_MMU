SetActiveLib -work
comp -include "$dsn\src\main.vhd" 
comp -include "$dsn\src\TestBench\mmu_TB.vhd" 
asim +access +r TESTBENCH_FOR_mmu 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg virtual_address
wave -noreg physical_address
wave -noreg page_fault
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\mmu_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_mmu 
