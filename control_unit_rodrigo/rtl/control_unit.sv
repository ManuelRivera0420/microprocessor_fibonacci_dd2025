`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 14.11.2025 18:24:51
// Design Name: 
// Module Name: control_unit
//////////////////////////////////////////////////////////////////////////////////

// TEST REPO
module control_unit(
    input logic clk,
    input logic arst_n,
    input logic [6:0] opcode,
    output logic branch,
    output logic memread,
    output logic memtoreg,
    output logic aluop,
    output logic memwrite,
    output logic alusource,
    output logic regwrite
    );
//Define te instructions 
    localparam R_TYPE  = 7'b011_0011;  // Arithmetic and logical operations
    localparam I_LOAD  = 7'b000_0011;  // Load data from memory
    localparam I_TYPE  = 7'b001_0011;  // Immediate value operations
    localparam S_TYPE  = 7'b010_0011;  // Store data in memory
    localparam B_TYPE  = 7'b110_0011;  // Conditional branches
    localparam JAL     = 7'b110_1111;  // Unconditional jump and link
    localparam JALR    = 7'b110_0111;  // Jump to register location
    localparam LUI     = 7'b011_0111;  // Load upper immediate
    localparam AUIPC   = 7'b001_0111;  // Add upper immediate to PC
    
always_ff @(posedge clk, negedge arst_n) begin 
    if(!arst_n) begin 
        branch <= '0;
        memread <= '0; 
        memtoreg <= '0;
        aluop <= '0;
        memwrite <= '0;
        alusource <= '0;
        regwrite <= '0;
    end else begin 
        case (opcode)
           ////logic  
        endcase
    end
end
endmodule
