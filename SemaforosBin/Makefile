all :
	@mkdir -p trab
	@ghdl -i --workdir=trab --ieee=synopsys -fexplicit src/*.vhd bench/*.vhd
	@ghdl -m --workdir=trab --ieee=synopsys -fexplicit semaphores_tb 
run :
	./semaphores_tb --vcd=MipsSim.vcd --stop-time=80000ns

clean:
	rm -f  MipsSim.vcd sim_minimips trab/* bench/*~ src/*~ *~
