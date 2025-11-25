`timescale 1ns / 1ps

/*
 * TO DO:
 * Verify proper functionality with Control Unit
 * Remove operations that might be unused in the final design
 */

// ALU for basic arithmetic instructions in RV32I
module alu #(parameter N = 32)(
    input logic [N-1:0] reg_source1,    // First operand, sourced from a register 
    input logic [N-1:0] reg_source2,    // Second operand sourced from a register
    //input logic [N-1:0] imm_in,         // Second operand sourced from immediate generator
    //input logic [N-1:0] pc_in,          // First operand sourced from program counter
    //input logic alusrc_r1,              // ALUsrc selector for the first operand
    //input logic alusrc_r2,              // ALUsrc selector for the second operand 
    input logic [3:0]   alucontrol,     // Use 4 bits for the opcode at the moment 
    output logic zero,
    output logic [N-1:0] reg_destiny    // ALU result, destiny is another register
    );

`include "defines.svh"

// internal signals
//logic [N-1:0] first_operand;
//logic [N-1:0] second_operand;

    // MUX to determine second operator; if true, use immediate value
    //assign second_operand = alusrc_r2 ? imm_in : reg_source2;
    //assign first_operand = alusrc_r1 ? pc_in : reg_source1;

    always_comb begin
        unique case(alucontrol)
            ALU_ADD: begin  // At the moment we don't care about the carry
                reg_destiny = reg_source1 + reg_source2;
            end
            ALU_SUB: begin
                reg_destiny = reg_source1 - reg_source2;
            end
            ALU_AND: begin
                reg_destiny = reg_source1 & reg_source2;
            end
            ALU_OR: begin
                reg_destiny = reg_source1 | reg_source2;
            end
            ALU_XOR: begin
                reg_destiny = reg_source1 ^ reg_source2;
            end
            ALU_EQ: begin
                reg_destiny = reg_source1 == reg_source2;
            end
            ALU_SLT: begin  // Compare sign bit
                if (reg_source1[N-1] != reg_source2[N-1]) begin
                    // Find which operand has the negative sign
                    reg_destiny = reg_source1[N-1] > reg_source2[N-1];
                end else begin
                    // IF MSB is equal, compare bits directly
                    reg_destiny = reg_source1[N-2:0] < reg_source2[N-2:0];
                end
            end
            ALU_SLTU: begin
                reg_destiny = reg_source1 < reg_source2;
            end
            ALU_SLL: begin
                reg_destiny = reg_source1 << reg_source2;
            end
            ALU_SRL: begin
                reg_destiny = reg_source1 >> reg_source2;
            end
            ALU_SRA: begin
                // >>>: Arithmetic right shift preserves MSB if data vector is signed
                reg_destiny = $signed(reg_source1) >>> reg_source2; // Implementation could be hard-coded if needed
            end
            // Send nothing as a default case
            default: reg_destiny = '0;
        endcase
    end
    
    assign zero = (reg_destiny == 0);
    
    // Implementation below generates a latch
/*
    always_comb begin
        if (reg_destiny == 0) begin 
            zero = 1'b1;
        end
    end
 */
endmodule
