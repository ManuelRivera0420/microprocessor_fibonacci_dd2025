# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2023.09
# platform  : Linux 4.19.0-20-amd64
# version   : 2023.09 FCS 64 bits
# build date: 2023.09.27 19:40:18 UTC
# ----------------------------------------
# started   : 2025-12-01 18:51:46 UTC
# hostname  : joc044.(none)
# pid       : 13744
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:32851' '-style' 'windows' '-data' 'AAAA7HicfYwxCsJQEETfJ8TawtIrRDQQFElhk04JSWGbIqhElIiKRRo9qjf5mXwJaOMMM8PuDmuA+GmtxcFrZEPWbMhJ5ClbJSyJCFkwZcVMPnGaS5Hm/1cH8/4kseEbJnv9JPh9sa940ogjBwr2XHjo752Sk/YDAkcYc6bS9kqtTuclO25iralDC2qgGlo=' '-proj' '/home/joc/piezo/microprocessor_fibonacci_dd2025/fv/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/joc/piezo/microprocessor_fibonacci_dd2025/fv/jgproject/.tmp/.initCmds.tcl' 'jg_fpv.tcl'
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
