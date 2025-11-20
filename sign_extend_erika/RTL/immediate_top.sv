`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 02:27:35
// Design Name: 
// Module Name: immediate_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module immediate_top (
    input  logic [31:0] instr,     // Instruction
    input  logic        imm_sel,   // 0 = Instruction type I, 1 = Instruction type S of control unit
    output logic [31:0] imm32,
    output logic [31:0] imm32_branch
);
    logic [11:0] imm12_out;      // output for module extend sign
    logic [12:0] imm13_branch_out; 
    immediate_generator imm1 (
        .instr(instr),    
        .imm_sel(imm_sel),
        .imm12_out(imm12_out),
        .imm13_branch_out(imm13_branch_out)
    );

    extend_sign #(.WIDTH_IN(12), .WIDTH_OUT(32)) extend1 (
        .imm_in(imm12_out),
        .imm_out(imm32)           //output for  ALU
    );
   extend_sign #(.WIDTH_IN(13), .WIDTH_OUT(32)) extend_branch (
        .imm_in(imm13_branch_out),
        .imm_out(imm32_branch)           //output for  PC
    );

endmodule

