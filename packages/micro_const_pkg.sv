/*
 * Package containing all the constants share across files
 * Make sure to import the package at the beggining of your rtl/tb file
 */
package micro_const_pkg;
    // Operational Codes for ALU
    parameter ALU_ADD  = 4'b0000; // Addition
    parameter ALU_SUB  = 4'b0001; // Substraction
    parameter ALU_AND  = 4'b0010; // Bitwise AND
    parameter ALU_OR   = 4'b0011; // Bitwise OR
    parameter ALU_XOR  = 4'b0100; // Bitwise XOR
    parameter ALU_EQ   = 4'b0101; // Set if equal
    parameter ALU_SLT  = 4'b0110; // Set if Less Than
    parameter ALU_SLTU = 4'b1000; // Set if Less Than unsigned
    parameter ALU_SLL  = 4'b1001; // Shift Left Logic
    parameter ALU_SRL  = 4'b1010; // Shift Right Logic
    parameter ALU_SRA  = 4'b1011; // Shift Right Arithmetic

    // Other constants...
    
endpackage
