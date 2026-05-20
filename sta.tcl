read_liberty /home/sasha/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130B/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. связываем дизайн
read_verilog counter_out.v
link_design counter

# 3. Создаем виртуальный тактовый сигнал на порту 'clk' с периодом 10 нс
create_clock -name sys_clk -period 10.0 [get_ports clk]

# Задаем дефолтные задержки на входных и выходных портах
set_input_delay -clock sys_clk 2.0 [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -clock sys_clk 2.0 [all_outputs]

report_checks -path_delay max -digits 4
report_checks -path_delay min -digits 4

report_wns
report_tns

exit

