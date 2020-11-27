onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_edge_detection/clk
add wave -noupdate -radix unsigned /tb_edge_detection/reset_n
add wave -noupdate -radix unsigned /tb_edge_detection/hdmi_vsync
add wave -noupdate -radix unsigned /tb_edge_detection/hdmi_hsync
add wave -noupdate -radix unsigned /tb_edge_detection/hdmi_de
add wave -noupdate -radix unsigned /tb_edge_detection/hdmi_data
add wave -noupdate -radix unsigned /tb_edge_detection/h_verify
add wave -noupdate -radix unsigned /tb_edge_detection/v_verify
add wave -noupdate -radix unsigned /tb_edge_detection/edge_vsync
add wave -noupdate -radix unsigned /tb_edge_detection/edge_hsync
add wave -noupdate -radix unsigned /tb_edge_detection/edge_de
add wave -noupdate -radix unsigned /tb_edge_detection/edge_data
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/line0
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/line1
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/line2
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/D
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/y_value
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/new_y_value_x
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/new_y_value_y
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/y_result
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/gx
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/gy
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/g_sum
add wave -noupdate -radix unsigned /tb_edge_detection/edge_detection_u0/y_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {111042819 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 335
configure wave -valuecolwidth 199
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {100110623 ps} {135935377 ps}
