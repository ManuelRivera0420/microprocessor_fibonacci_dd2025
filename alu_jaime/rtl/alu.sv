`timescale 1ns / 1ps

/*
 * TO DO:
 * Replace temporal OpCodes for the proper Codes
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
    
    // Temporal OpCodes
    localparam ADD  = 4'b0000; // Addition
    localparam SUB  = 4'b0001; // Substraction
    
    localparam AND  = 4'b0010; // Bitwise AND
    localparam OR   = 4'b0011; // Bitwise OR
    localparam XOR  = 4'b0100; // Bitwise XOR

    localparam EQ   = 4'b0101; // Set if equal
    localparam SLT  = 4'b0110; // Set if Less Than
    localparam SLTU = 4'b1000; // Set if Less that unsigned

    localparam SLL  = 4'b1001; // Shift Left Logic
    localparam SRL  = 4'b1010; // Shift Right Logic
    localparam SRA  = 4'b1011; // Shift Right Arithmetic

    logic [N-1:0] second_operand;

    // MUX to determine second operator
    assign second_operand = alusrc ? reg_source2 : immg_source;

    always_comb begin
        unique case(instruction)
            ADD: begin  // At the moment we don't care about the carry
                reg_destiny = reg_source1 + second_operand;
            end
            SUB: begin
                reg_destiny = reg_source1 - second_operand;
            end
            AND: begin
                reg_destiny = reg_source1 & second_operand;
            end
            OR: begin
                reg_destiny = reg_source1 | second_operand;
            end
            XOR: begin
                reg_destiny = reg_source1 ^ second_operand;
            end
            EQ: begin
                reg_destiny = reg_source1 == second_operand;
            end
            SLT: begin  // Compare sign bit
                if (reg_source1[N-1] != second_operand[N-1]) begin
                    // Find which operand has the negative sign
                    reg_destiny = reg_source1[N-1] > second_operand[N-1];
                end else begin
                    // IF MSB is equal, compare bits directly
                    reg_destiny = reg_source1[N-2:0] < second_operand[N-2:0];
                end
            end
            SLTU: begin
                reg_destiny = reg_source1 < second_operand;
            end
            SLL: begin
                reg_destiny = reg_source1 << second_operand;
            end
            SRL: begin
                reg_destiny = reg_source1 >> second_operand;
            end
            SRA: begin
                // >>>: Arithmetic right shift preserves MSB
                reg_destiny = reg_source1 >>> second_operand;
            end
            // Send an undefined signal for non-specified OpCodes
            default: reg_destiny = 'x;
        endcase
    end
endmodule
