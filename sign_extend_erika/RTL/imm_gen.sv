`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 10:44:41 PM
// Design Name: 
// Module Name: imm_gen
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module imm_gen(
    input logic [31:0] instr,
    input logic [2:0] imm_sel,
    output logic [31:0] imm_out
    );
    //local params
    localparam IMM_I = 3'b000;   // Type I  (ADDI, LW, JALR, etc.)
    localparam IMM_S = 3'b001;   // Type S  (SW, SH, SB)
    localparam IMM_B = 3'b010;   // Type B  (BEQ, BNE, etc.)
    localparam IMM_U = 3'b011;   // Type U  (LUI, AUIPC)
    localparam IMM_J = 3'b100;   // Type J  (JAL)

always_comb begin 
    unique case (imm_sel)
        IMM_I: begin 
            imm_out = {{20{instr[31]}}, instr[31:20]}; //signed extension (repeat 20 times the MSB)
        end
        			/*
                            31     30:25    24:20   19:15   14:12   11:8       7      6:0
                          imm[12] imm[10:5]  rs2    rs1   funct3   imm[4:1] imm[11]  opcode

			*/
        IMM_B: begin 
            imm_out = { {20{instr[31]}}, {instr[7], instr[30:25], instr[11:8], 1'b0 } };
        end
        /*
                          31       30:21     20     19:12    11:7    6:0
                        imm[20] imm[10:1] imm[11] imm[19:12]  rd   opcode
        */
        IMM_J: begin 
            imm_out = { {20{instr[31]}}, {instr[19:12], instr[20], instr[30:21], 1'b0 } };
        end
    endcase
end

endmodule

