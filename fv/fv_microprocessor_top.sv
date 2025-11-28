module fv_microprocessor_top (
//Blackbox signals
input logic clk, 
input logic arst_n,
input logic [DATA_WIDTH-1:0] instruction,
input logic memread , 
input logic memwrite, 
input logic memtoreg, 
input logic [DATA_WIDTH-1:0] alu_result,

//Whitebox signals
//Registers bank
input logic [DATA_WIDTH-1:0] prf [1:DATA_WIDTH-1],
input logic [DATA_WIDTH-1:0] pc_out,
input logic [DATA_WIDTH-1:0] pc_imm
);
  `include "includes.svh"

	//`ASM(asm, instr_asm, 1'b1 |->,  instruction == 32'h0010_0133);
	// 
	logic [4:0] rs1, rs2, rd;
	logic [2:0] func3;
	logic [6:0] func7;
	logic [31:0] tb_instr_add;
	logic [31:0] tb_instr_addi;
	logic [31:0] tb_instr_beq;
	logic [31:0] tb_instr_jal;
	logic [6:0] opcode;
	logic [11:0] imm;
	logic [12:0] imm_beq;
	logic [20:0] imm_jal;

	`ASM(asm, fields_stable, 1'b1 |->,  $stable({rs1,rs2,rd,func3,func7}));
	`ASM(asm, instr, 1'b1 |->,  instruction == tb_instr_addi);

	`ASM(asm, no_x0, 1'b1 |->,  (|rs1) & (|rs2) & (|rd));
	`ASM(asm, func3_always_0, 1'b1 |->,  ~(|func3));

	//`ASM(asm, add_only, 1'b1 |->,  opcode == OPCODE_R_TYPE[6:0]);
	//`ASM(asm, addi_only, 1'b1 |->,  opcode == OPCODE_I_TYPE[6:0] );
	//`ASM(asm, beq_only, 1'b1 |->,  opcode == OPCODE_B_TYPE[6:0] );
	`ASM(asm, jal_only, 1'b1 |->,  opcode == OPCODE_J_TYPE[6:0] );

	assign tb_instr_add = {func7, rs2, rs1, func3, rd, opcode};
	assign tb_instr_addi = {imm , rs1, func3, rd, opcode};
	assign tb_instr_beq = {imm_beq[12], imm_beq[10:5], rs2, rs1, func3, imm_beq[4:1], imm_beq[11], opcode};
	assign tb_instr_jal = {imm_jal[20], imm_jal[10:1], imm_jal[11], imm_jal[19:12], rd, opcode};

	

  // add instruction (add x2, x0, x1) -- failed
  `AST(uC, add_instruction,
    instruction[6:0] == OPCODE_R_TYPE[6:0] |=>,
    prf[rd] == $past(prf[rs1]) + $past(prf[rs2])
  )

  // addi instruction (addi rd, rs1)
  `AST(uC, addi_instruction,
    instruction[6:0] == OPCODE_I_TYPE[6:0] |=>,
    $signed(prf[rd]) == $signed($past(prf[rs1])) + $signed($past(imm))
  )

  // beq -- failed
  `AST(uC, beq_instruction,
    instruction[6:0] == OPCODE_B_TYPE[6:0] |=>, 
		$past(prf[rs1] == prf[rs2]) ? 
		pc_i.pc == $past(pc_i.pc + imm_beq) : // branch taken
		pc_i.pc == $past(pc_i.pc + 4) // branch not taken
)

  // jal -- failed
  `AST(uC, jal_instruction,
    instruction[6:0] == OPCODE_J_TYPE[6:0] |=>, 
		pc_i.pc == $past(pc_i.pc + imm_jal) // unconditional jump
)

  //// sub instruction (sub x2, x0, x1)
  //`AST(uC, sub_instruction,
  //  instruction == 32'h4010_0133 |=>,
  //  prf[2] == prf[0]-prf[1]
  //)

  //// beq instruction (beq x4 x5 4095)
  //`ASM(prf, beq, 1'b1 |->, prf[4] == prf[5])
  //`AST(uC, beq_instruction,
  //  instruction == 32'h7e52_0fe3 |=>,
  //  pc_imm == 12'hFFF
  //)


endmodule

bind microprocessor_top fv_microprocessor_top fv_microprocessor_i (
    // blackbox
    .clk        (clk),
    .arst_n     (arst_n),
    .instruction(instruction),
    .memread    (memread),
    .memwrite   (memwrite),
    .memtoreg   (memtoreg),
    .alu_result (alu_result),
    // whitebox
    .prf (prf_i.prf),   //Registers bank
    .pc_out(pc_out),
    .pc_imm(pc_imm_in)
);

