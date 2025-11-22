`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 02:26:58 AM
// Design Name: 
// Module Name: program_counter
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module program_counter(
    input logic clk,
    input logic arst_n,
    input logic pc_write,
    input logic [1:0] pc_sel,
    input logic [31:0] imm_in,
    output logic [31:0] pc
);
    //define the PC count logic instructions 
    localparam PC_4 = 2'b00;
    localparam PC_IMM = 2'b01; 
    
    //Secuential logic 
    always_ff @(posedge clk, negedge arst_n) begin
        if (!arst_n) begin
            pc <= 32'h0000_0000;
        end else if (pc_write) begin
            unique case (pc_sel)
                PC_4: begin 
                    pc <= pc + 4;        
                end
                PC_IMM: begin
                    pc <= pc + imm_in;
                end 
                default: begin 
                    pc <= pc;
                end    
            endcase
        end 
    end    
    
endmodule

