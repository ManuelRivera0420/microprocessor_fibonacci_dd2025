clear -all

	analyze -sv ../../defines.svh
	analyze -sv ../rtl/bank_reg_s.sv

  analyze -sv12 fv_bank_reg_s.sv
 
elaborate  -bbox_a 65535 -bbox_mul 65535 -top bank_reg_s
#elaborate -top data_management_system

clock clk
reset -expression !arst_n

set_engineJ_max_trace_length 2000
