onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib blk_mem_cl_kernel_buf_opt

do {wave.do}

view wave
view structure
view signals

do {blk_mem_cl_kernel_buf.udo}

run -all

quit -force
