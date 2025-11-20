`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 05:02:30
// Design Name: 
// Module Name: tb_immediate
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

module tb_immediate();

    logic [31:0] instr;
    bit        imm_sel;
    logic [31:0] imm32;
    logic [31:0] imm32_branch;

    // DUT
    immediate_top dut (
        .instr(instr),
        .imm_sel(imm_sel),
        .imm32(imm32),
        .imm32_branch(imm32_branch)
    );

    initial begin
        // I-type (ADDI)
        imm_sel = 0;
        instr = 32'b00000000000000000000010100010011; #10;
        instr = 32'b00000000000100000000010110010011; #10;
        instr = 32'b00000000101000000000011000010011; #10;
        instr = 32'b11111111111101100000011000010011; #10;
        imm_sel = 1;
        instr = 32'b00000000001000001010100000100011; #10;
        // B-type 
        instr = 32'b11111110000001100001101011100011; #10;


        $finish;
    end

endmodule
