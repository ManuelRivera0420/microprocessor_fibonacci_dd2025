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

    logic [31:0] instr;        // Input:Instructions from program memory
    bit          imm_sel;      // Input:  0 = Instruction type I, 1 = Instruction type S of control unit
    logic [31:0] imm32;        // Output for instruction type I and S
    logic [31:0] imm32_branch; // Output for instruction type B
    logic [31:0] expected_i;   // expected Output for instruction type I 
    logic [31:0] expected_s;   // expected Output for instruction type s
    logic [31:0] expected_b;   // expected Output for instruction type B
    // DUT
    immediate_top dut (
        .instr(instr),
        .imm_sel(imm_sel),
        .imm32(imm32),
        .imm32_branch(imm32_branch)
    );

    initial begin
        // -Case I-type 
        imm_sel = 0;
        instr = 32'b00000000000000000000010100010011; #10;
        expected_i = { {20{instr[31]}}, instr[31:20] };
        assert (imm32 === expected_i)
            $display("MATCH | instr=%b imm32_branch=%h esperado=%h",  instr, imm32, expected_i);
            else $error("I-type failed: instr=%b imm32=%h esperado=%h", instr, imm32, expected_i);

        // Case S-type
        imm_sel = 1;
        instr = 32'b00000000001000001010100000100011; #10;
        expected_s = { {20{instr[31]}}, {instr[31:25], instr[11:7]} };
        assert (imm32 === expected_s)
            $display("MATCH | instr=%b imm32_branch=%h esperado=%h",  instr, imm32, expected_s);
            else $error("S-type failed: instr=%b imm32=%h esperado=%h", instr, imm32, expected_s);

        // Case B-type 
        instr = 32'b11111110000001100001101011100011; #10;
        expected_b = { {19{instr[31]}}, {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} };
        assert (imm32_branch === expected_b)
            $display("MATCH | instr=%b imm32_branch=%h esperado=%h",  instr, imm32, expected_b);
            else $error("B-type failed: instr=%b imm32_branch=%h esperado=%h", instr, imm32_branch, expected_b);

        $finish;
    end

endmodule


