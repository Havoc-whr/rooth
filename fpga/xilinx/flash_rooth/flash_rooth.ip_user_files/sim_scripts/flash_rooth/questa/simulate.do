onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib flash_rooth_opt

do {wave.do}

view wave
view structure
view signals

do {flash_rooth.udo}

run -all

quit -force
