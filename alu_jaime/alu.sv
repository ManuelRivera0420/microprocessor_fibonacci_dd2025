`timescale 1ns / 1ps

/*
 * TO DO: Replace temporal OpCodes for the proper Codes
 * (Possibly) write a module for each operation with primitives if necessary
 * Double check if this are all the base arithmetic operations of RV32I
 * IMPORTANT
 * add a mux to select weather the second oparasator is rs2 or data from imm generator
 * change the input instruction to 4 bits 
 */
// ALU for R type arithmetic instructions 
module alu #(parameter N = 32)(
    input logic [N-1:0] reg_source1,
    input logic [N-1:0] reg_source2,
    input logic [6:0]   instruction,
    output logic [N-1:0] reg_destiny
    );
    
    // Temporal OpCodes
    localparam ADD  = 000_0000; // Addition
    localparam SUB  = 000_0001; // Substraction
 
    localparam AND  = 000_0010; // Bitwise AND
    localparam OR   = 000_0011; // Bitwise OR
    localparam XOR  = 000_0100; // Bitwise XOR

    localparam EQ   = 000_0101; // Set if equal
    localparam SLT  = 000_0110; // Set if Less Than
    localparam SLTU = 000_1000; // Set if Less that unsigned

    localparam SLL  = 000_1001; // Shift Left Logic
    localparam SRL  = 000_1010; // Shift Right Logic
    localparam SRA  = 000_1011; // Shift Right Arithmetic


    always_comb begin
        case(instruction):
            ADD: begin
                // For the moment we don't care about the carry
                reg_destiny = reg_source1 + reg_source2;
            end
            SUB: begin
                reg_destiny = reg_source1 - reg_source2;
            end
            AND: begin
                reg_destiny = reg_source1 & reg_source2;
            end
            OR: begin
                reg_destiny = reg_source1 | reg_source2;
            end
            XOR: begin
                reg_destiny = reg_source1 ^ reg_source2;
            end
            EQ: begin
                reg_destiny = reg_source1 == reg_source2;
            end
            SLT: begin  // Compare sign bit
                if reg_source1[N-1] != reg_source2[N-1] begin
                    // Find which operand has the negative sign
                    reg_destiny = reg_source1[N-1] > reg_source2[N-1];
                end else begin
                    // IF MSB is equal, compare bits directly
                    reg_destiny = reg_source1[N-2:0] < reg_source2[N-2:0];
                end
            end
            SLTU: begin
                reg_destiny = reg_source1 < reg_source2;
            end
            SLL: begin
                reg_destiny = reg_source1 << reg_source2;
            end
            SRL: begin
                reg_destiny = reg_source1 >> reg_source2;
            end
            SRA: begin
                // >>>: Arithmetic right shift preserves MSB
                reg_destiny = reg_source1 >>> reg_source2;
            end
            // Send an undefined signal for non-specified OpCodes
            default: reg_destiny = 'x;
        endcase
    end
endmodule
