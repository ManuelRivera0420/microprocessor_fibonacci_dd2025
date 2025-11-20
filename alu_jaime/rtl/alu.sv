`timescale 1ns / 1ps
import micro_const_pkg::*;

/*
 * TO DO:
 * Verify proper functionality with Control Unit
 * Remove operations that might be unused in the final design
 * THINGS TO CONSIDER:
 * Currently, repeated addition is unsuported because of the lack of carry-in input
 * and carry-out/overflow flag.
 */

// ALU for basic arithmetic instructions in RV32I
module alu #(parameter N = 32)(
    input logic [N-1:0] reg_source1,    // First operand, sourced from a register 
    input logic [N-1:0] reg_source2,    // Second operand sourced from a register
    input logic [N-1:0] immg_source,    // Second operand sourced from immediate generator
    input logic alusrc,                 // ALUsrc selector for the second operand 
    input logic [3:0]   instruction,    // Use 4 bits for the opcode at the moment 
    output logic [N-1:0] reg_destiny    // ALU result, destiny is another register
    );
    
    logic [N-1:0] second_operand;

    // MUX to determine second operator; if true, use immediate value
    assign second_operand = alusrc ? immg_source : reg_source2;

    always_comb begin
        unique case(instruction)
            ALU_ADD: begin  // At the moment we don't care about the carry
                reg_destiny = reg_source1 + second_operand;
            end
            ALU_SUB: begin
                reg_destiny = reg_source1 - second_operand;
            end
            ALU_AND: begin
                reg_destiny = reg_source1 & second_operand;
            end
            ALU_OR: begin
                reg_destiny = reg_source1 | second_operand;
            end
            ALU_XOR: begin
                reg_destiny = reg_source1 ^ second_operand;
            end
            ALU_EQ: begin
                reg_destiny = reg_source1 == second_operand;
            end
            ALU_SLT: begin  // Compare sign bit
                if (reg_source1[N-1] != second_operand[N-1]) begin
                    // Find which operand has the negative sign
                    reg_destiny = reg_source1[N-1] > second_operand[N-1];
                end else begin
                    // IF MSB is equal, compare bits directly
                    reg_destiny = reg_source1[N-2:0] < second_operand[N-2:0];
                end
            end
            ALU_SLTU: begin
                reg_destiny = reg_source1 < second_operand;
            end
            ALU_SLL: begin
                reg_destiny = reg_source1 << second_operand;
            end
            ALU_SRL: begin
                reg_destiny = reg_source1 >> second_operand;
            end
            ALU_SRA: begin
                // >>>: Arithmetic right shift preserves MSB
                reg_destiny = reg_source1 >>> second_operand;
            end
            // Send an undefined signal for non-specified OpCodes
            default: reg_destiny = 'x;
        endcase
    end
endmodule
