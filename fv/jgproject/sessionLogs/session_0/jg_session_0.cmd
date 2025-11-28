# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2023.09
# platform  : Linux 4.19.0-20-amd64
# version   : 2023.09 FCS 64 bits
# build date: 2023.09.27 19:40:18 UTC
# ----------------------------------------
# started   : 2025-11-28 19:50:40 UTC
# hostname  : joc044.(none)
# pid       : 35934
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:44813' '-style' 'windows' '-data' 'AAAA9HicfYyxCsIwGIS/UHR28BG6KioURTK4uCmig2uHYkVRWlQcXPRRfZN4iQTq4v3cHf/9lxjAPp1zBCQPSYcFSzbMpSu2cpiSMWLCgBlDaT9wLGba/18DzPvrWEMTZv36cWjFYqwkYpcje3JKau7690bBSXmbXhhIOXNQeqFSx2vBjqum0pbrhc89Pk3jHBQ=' '-proj' '/home/joc/piezo/microprocessor_fibonacci_dd2025/fv/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/joc/piezo/microprocessor_fibonacci_dd2025/fv/jgproject/.tmp/.initCmds.tcl' 'jg_fpv.tcl'
clear -all

set sepIdx [lsearch $argv ---]
if {$sepIdx == -1 || [expr {$sepIdx + 1}] >= [llength $argv]} {
  puts "-Uso: jg -tcl jg_fpv.tcl --- <nombre_top_module>" 
  exit 1
}
set FV_TOP [lindex $argv [expr {$sepIdx + 1}]]

### add here secundary files for analysis if needed

### ----------------------------------

set RTL_DIR "/home/joc/piezo/microprocessor_fibonacci_dd2025/rtl"
set FV_DIR  "/home/joc/piezo/microprocessor_fibonacci_dd2025/fv"

foreach f {
  defines.svh
  mux.sv
  program_counter.sv
  physical_register_file.sv
  instruction_memory.sv
  imm_gen.sv
  alu.sv
  control_unit.sv
  microprocessor_top.sv
} {
  eval analyze -sv $RTL_DIR/$f
}

eval analyze -sv $FV_DIR/fv_$FV_TOP.sv

elaborate -top $FV_TOP
get_design_info

clock clk
reset -expression !arst_n

prove -all

visualize -violation -property <embedded>::microprocessor_top.fv_microprocessor_i.uC_ast_add_instruction -new_window
