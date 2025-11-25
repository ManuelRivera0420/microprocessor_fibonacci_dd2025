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
    input logic zero,  //Sign send by the rs1-rs2 alu 
    input logic [1:0] pc_sel,//Selection of variable to add type branch, Jal or +4 
    input logic [31:0] imm_in,//Immediate
    output logic [31:0] pc//Out of program counter
);

`include "defines.svh"

    
    //Secuential logic 
    always_ff @(posedge clk, negedge arst_n) begin
        if (!arst_n) begin
            pc <= 32'h0000_0000;
        end else if (pc_write) begin
            unique case (pc_sel)
                PC_4: begin 
                    pc <= pc + 4;        
                end
                PC_BRANCH: begin
                    if (zero) begin  //if branch taken
                        pc <= pc + imm_in; 
                    end else begin 
                        pc <= pc + 4;
                    end
                end 
                default: begin 
                    pc <= pc;
                end    
            endcase
        end 
    end    
endmodule


