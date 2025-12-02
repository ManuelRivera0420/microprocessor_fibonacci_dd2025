module fv_microprocessor_top (
//Blackbox signals
input logic clk, 
input logic arst_n,
input logic [DATA_WIDTH-1:0] instruction,
input logic memread, 
input logic memtoreg, 
input logic [DATA_WIDTH-1:0] data_out
);
  `include "includes.svh"

	logic [4:0] rs1, rs2, rd;
	logic [2:0] funct3;
	logic [6:0] funct7;
	logic [31:0] tb_instr_add;
	logic [31:0] tb_instr_addi;
	logic [31:0] tb_instr_beq;
	logic [31:0] tb_instr_jal;
	logic [6:0] opcode;
	logic [11:0] imm_addi;
	logic [12:0] imm_beq;
	logic [20:0] imm_jal;

	//`ASM(asm, fields_stable, 1'b1 |->,  $stable({rs1,rs2,rd,funct3,funct7}));
	//`ASM(asm, fields_stable, 1'b1 |->,  $stable({funct7, rs2, rs1, funct3, rd, opcode}));

	`ASM(asm, no_x0, 1'b1 |->,  (|rs1) & (|rs2) & (|rd));
	`ASM(asm, funct3_always_0, 1'b1 |->, ~(|funct3));
	`ASM(asm, funct7_always_0, 1'b1 |->, ~(|funct7));  

  //`ASM(asm, instr, 1'b1 |->,  instruction == tb_instr_add);
	`ASM(asm, instr, 1'b1 |->,  instruction == tb_instr_addi);
  //`ASM(asm, instr, 1'b1 |->,  instruction == tb_instr_beq);
  //`ASM(asm, instr, 1'b1 |->,  instruction == tb_instr_jal);

	assign tb_instr_add = {funct7, rs2, rs1, funct3, rd, opcode};
	assign tb_instr_addi = {imm_addi , rs1, funct3, rd, opcode};
	assign tb_instr_beq = {imm_beq[12], imm_beq[10:5], rs2, rs1, funct3, imm_beq[4:1], imm_beq[11], opcode};
	assign tb_instr_jal = {imm_jal[20], imm_jal[10:1], imm_jal[11], imm_jal[19:12], rd, opcode};

  // add instruction (add rd, rs2, rs1)
  `AST(uC, add_instruction,
    tb_instr_add[6:0] == OPCODE_R_TYPE[6:0] |-> ,
    alu_i.alu_result == (prf_i.read_data1) + (prf_i.read_data2)
  )

  // addi instruction (addi rd, rs1) == Failed
  `AST(uC, addi_instruction,
    tb_instr_addi[6:0] == OPCODE_I_TYPE[6:0] |=>,
    $signed(prf_i.prf[rd]) == $past($signed(prf_i.prf[rs1]) + $signed(imm_addi))
  )

  // beq
  `AST(uC, beq_instruction,
    tb_instr_beq[6:0] == OPCODE_B_TYPE[6:0] |=>, 
		$past(prf_i.prf[rs1] == prf_i.prf[rs2]) ? 
		 pc_i.pc == $past(pc_i.pc + imm_gen_i.imm_out) : // branch taken
		 pc_i.pc == $past(pc_i.pc) + 32'd4 // branch not taken
)

  // jal
  `AST(uC, jal_instruction,
    tb_instr_jal[6:0] == OPCODE_J_TYPE[6:0] |=>, 
		pc_i.pc == $past(pc_i.pc + imm_gen_i.imm_out) // unconditional jump
)

endmodule

bind microprocessor_top fv_microprocessor_top fv_microprocessor_i (.*);

