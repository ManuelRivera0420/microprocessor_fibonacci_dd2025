module microprocessor_tb ();

//`include "defines.svh"

`define  MEM_PATH microprocessor_i.instruction_memory_i
`define  ALU_PATH microprocessor_i.alu_i
`define  BANK_REG_PATH microprocessor_i.prf_i
`define  PC_PATH microprocessor_i.pc_i
`define  IMM_GEN_PATH microprocessor_i.imm_gen_i
`define  MUX_PATH microprocessor_i.mux_imm_gen_i
`define  CU_PATH microprocessor_i.control_unit_i


bit clk;
bit arst_n;
logic [DATA_WIDTH - 1:0] instruction;

always #5ns clk = !clk;
assign #10ns arst_n = 1'b1;

initial begin 
    wait (arst_n);
    instruction = 32'b00000000000000000000010100010011;
		#10ms;
    $display("RESULT = %d", `ALU_PATH.alu_result);
		$display("RESULT = %d", `CU_PATH.opcode);
		$finish;
end




microprocessor microprocessor_i (
    .clk(clk),
    .arst_n(arst_n),
    .instruction(instruction)
);


	initial begin // Initial block to open shared memory and probe signals
			$shm_open("shm_db");
			$shm_probe("ASMTR");
	end



 endmodule
