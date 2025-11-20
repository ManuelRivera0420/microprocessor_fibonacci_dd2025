`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 01:40:14
// Design Name: 
// Module Name: immediate_generator
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


module immediate_generator (
    input  logic [31:0] instr,            // Instructions from program memory
    input  logic        imm_sel,          // 0 = I-type, 1 = S-type of control unit 
    output logic [11:0] imm12_out,        // output for ALU
    output logic [12:0] imm13_branch_out  // output for PC
);
    logic [11:0] imm_type_i;              //Local variable to store 12-bit immediates - Instructions type I
    logic [11:0] imm_type_s;              //Local variable to store 12-bit immediates - Instructions type S

    assign imm_type_i = instr[31:20];      //Extracts only bits [31:20] from the instruction
    assign imm_type_s = {instr[31:25], instr[11:7]};//Extracts only bits [31:20] + bits [11:7]from the instruction
    assign imm13_branch_out = {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};  //Extracts only bits: instr[31]+ instr[7] +instr[30:25]+instr[11:8]+1'b0 from the instruction
    assign imm12_out = (imm_sel == 1'b0) ? imm_type_i : imm_type_s;   // Output depends on the signal received from the control unit

    
   
endmodule

