vlib work
vlog DSP_PROJECT.v DSP_PROJECT_TB.v
vsim -voptargs=+acc work.DSP_PROJECT_TB
add wave *
run -all
#quit -sim
