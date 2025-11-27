module fv_microprocessor (
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
input logic [DATA_WIDTH-1:0] prf [0:DATA_WIDTH-1],
input logic [DATA_WIDTH-1:0] pc_out,
input logic [DATA_WIDTH-1:0] pc_imm
);
  `include "includes.svh"
  // add instruction (add x2, x0, x1)
  `AST(uC, add_instruction,
    instruction == 32'h0010_0133 |=>,
    prf[2] == prf[0]+prf[1]
  )

  // sub instruction (sub x2, x0, x1)
  `AST(uC, sub_instruction,
    instruction == 32'h4010_0133 |=>,
    prf[2] == prf[0]-prf[1]
  )

  // beq instruction (beq x4 x5 4095)
  `ASM(prf, beq, 1'b1 |->, prf[4] == prf[5])
  `AST(uC, beq_instruction,
    instruction == 32'h7e52_0fe3 |=>,
    pc_imm == 12'hFFF
  )


endmodule

bind microprocessor fv_microprocessor fv_microprocessor_i (
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

