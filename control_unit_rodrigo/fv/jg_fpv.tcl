clear -all

set sepIdx [lsearch $argv ---]
if {$sepIdx == -1 || [expr {$sepIdx + 1}] >= [llength $argv]} {
  puts "-Uso: jg -tcl jg_fpv.tcl --- <nombre_top_module>" 
  exit 1
}
set FV_TOP [lindex $argv [expr {$sepIdx + 1}]]

### add here secundary files for analysis if needed

### ----------------------------------

set RTL_DIR "/home/disdig/microprocessor_fibonacci_dd2025/control_unit_rodrigo/rtl"
set FV_DIR  "/home/disdig/microprocessor_fibonacci_dd2025/control_unit_rodrigo/fv"

foreach f {
  defines.svh
  mux.sv
  program_counter.sv
  bank_reg_s.sv
  instruction_memory.sv
  imm_gen.sv
  alu.sv
  control_unit.sv
  microprocessor.sv
} {
  eval analyze -sv $RTL_DIR/$f
}

eval analyze -sv $FV_DIR/fv_$FV_TOP.sv

elaborate -top $FV_TOP
get_design_info

clock clk
reset -expression !arst_n

prove -all

