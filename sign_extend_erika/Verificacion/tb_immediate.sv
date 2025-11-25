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
    logic [2:0]  imm_sel;      // 000 = I-type, 001 = S-type ,010 = B-type, 011 = U-type, 100 = J-type of control unit 
    logic [31:0] imm_out;        // Output for instruction type I , S, B,U J
    logic [31:0] expected;     // expected Output for instruction type I 

    // DUT

   imm_gen dut (
        .instr(instr),
        .imm_sel(imm_sel),
        .imm_out(imm_out)
    );

    initial begin
        // -Case I-type 
        imm_sel = 3'b000;
        instr = 32'b00000000000000000000010100010011; #10;
        expected = { {20{instr[31]}}, instr[31:20] };
        assert (imm_out === expected)
            $display("MATCH I-type | instr=%b imm_out=%h esperado=%h",  instr, imm_out, expected);
            else $error("I-type failed: instr=%b imm_out=%h esperado=%h", instr, imm_out, expected);

        // Case S-type
        imm_sel = 3'b001;
        instr = 32'b00000000001000001010100000100011; #10;
        expected = { {20{instr[31]}}, {instr[31:25], instr[11:7]} };
        assert (imm_out === expected)
            $display("MATCH S-type | instr=%b imm_out=%h esperado=%h",  instr, imm_out, expected);
            else $error("S-type failed: instr=%b imm_out=%h esperado=%h", instr, imm_out, expected);

        // Case B-type 
        imm_sel = 3'b010;
        instr = 32'b11111110000001100001101011100011; #10;
        expected = { {19{instr[31]}}, {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} };
        assert (imm_out === expected)
            $display("MATCH B-type | instr=%b imm_out=%h esperado=%h",  instr, imm_out, expected);
            else $error("B-type failed: instr=%b imm_outh=%h esperado=%h", instr, imm_out, expected);
            
        // Case U-type 
        imm_sel = 3'b011;
        instr = 32'b00000000000010101011010100110111; #10;
        expected = {  instr[31:12], {12{1'b0}} };
        assert (imm_out === expected)
            $display("MATCH U-type | instr=%b imm_out=%h esperado=%h",  instr, imm_out, expected);
            else $error("U-type failed: instr=%b imm_out=%h esperado=%h", instr, imm_out, expected);

        // Case J-type 
        imm_sel = 3'b100;
        instr = 32'b00000000100000000000000011101111; #10;
        expected = { {12{instr[31]}}, {instr[19:12], instr[20], instr[30:21], 1'b0 } };
        assert (imm_out === expected)
            $display("MATCH B-type | instr=%b imm_out=%h esperado=%h",  instr, imm_out, expected);
            else $error("B-type failed: instr=%b imm_out=%h esperado=%h", instr, imm_out, expected);
        $finish;
    end

endmodule


