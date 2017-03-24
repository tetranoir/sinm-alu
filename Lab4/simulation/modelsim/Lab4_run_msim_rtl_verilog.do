transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/TopLevel2.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/pc_exam.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/instr_ROM.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/definitions.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/dataMem.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/reg_file.sv}
vlog -sv -work work +incdir+C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4 {C:/Users/tetranoir/Desktop/class/cse141l/sinm-alu/Lab4/ALU.sv}

