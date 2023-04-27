default: \
		clean \
		vcsall
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------
# VCS
vcsnew   :
	vcs  \
	  -f file_list ../tb/tb_rooth_compliance.v  \
        -timescale=1ns/1ns \
        -full64  -R  +vc  +v2k  -sverilog  -debug_access+all -fsdb +define+FSDB \
        |tee vcs.log
vcsall   :
	vcs  \
	  -f file_list ../tb/tb_rooth_alltest.v  \
        -timescale=1ns/1ns \
        -full64  -R  +vc  +v2k  -sverilog  -debug_access+all -fsdb +define+FSDB \
        |tee vcs.log
vcsone   :
	vcs  \
	  -f file_list ../tb/tb_rooth.v \
        -timescale=1ns/1ns \
        -full64  -R  +vc  +v2k  -sverilog  -debug_access+all -fsdb +define+FSDB \
        |tee vcs.log
vcs   :
	python3 ./compliance_test.py $(isa)
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------
all: \
		vcs \
		verdi

#-------------------------------------------------------------------------------------------------------
# questasim

questasim: com sim
com:
	vlib work 
	vmap work work
	vlog -64 -sv +acc \
	-f file_list \
	-l com_questa.log

sim:
	vsim \
		-64 -batch -pli $(VERDI_HOME)/share/PLI/MODELSIM/linux64/novas_fli.so \
		-t 1ns \
  		work.tb \
		-do "run -all"

#-------------------------------------------------------------------------------------------------------
# verdi

verdi  :
	verdi -sv -f file_list -ssf tb.fsdb &

#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd
	 rm -rf INCA_libs irun*
	 rm -rf modelsim.ini transcript work
	 rm -rf result.output
#-------------------------------------------------------------------------------------------------------
