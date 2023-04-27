rm -f ./sim_out.vcd ./sim.out ./sim_out.vcd
echo "Compilation starts"
# define
iverilog -I ../rtl -y ../rtl -o sim.out $1
echo "Generate waveforms"
vvp -n sim.out
echo "View waveforms"
gtkwave sim_out.vcd
