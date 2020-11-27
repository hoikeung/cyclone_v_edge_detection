transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P {D:/Desktop/OV5642_1080P/de10_nano_d8m_ddr3.v}
vlib soc_system
vmap soc_system soc_system

vlog -sv -work work +incdir+D:/Desktop/OV5642_1080P/testbench {D:/Desktop/OV5642_1080P/testbench/tb_edge_detection.sv}
vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P/edge_detection {D:/Desktop/OV5642_1080P/edge_detection/add.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P/edge_detection {D:/Desktop/OV5642_1080P/edge_detection/edge_detection.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P/edge_detection {D:/Desktop/OV5642_1080P/edge_detection/shift_register.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P/edge_detection {D:/Desktop/OV5642_1080P/edge_detection/sqrt.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/OV5642_1080P/edge_detection {D:/Desktop/OV5642_1080P/edge_detection/square.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -L soc_system -voptargs="+acc"  tb_edge_detection

add wave *
view structure
view signals
run -all
