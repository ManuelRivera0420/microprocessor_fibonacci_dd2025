`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Laura Sabina Bañuelos Zendrero
// 
// Create Date: 27.11.2025 10:49:58
// Module Name: ram_instruct
// Project Name: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_instruct(
    input logic clk,
    input logic wren,
    input logic [5:0] wraddr,
    input logic [7:0] wrdata,
    input logic rden,
    input logic [5:0] rdaddr,
    output logic [31:0] rddata
    );
    
    logic [5:0] mem [5]; // Array - memory
    logic [7:0] count;

    always_ff@(posedge clk) begin // Writing port
        if(wren)
            mem[wraddr] <= wrdata;
    end
    
    assign rddata = rden ? mem[rdaddr] : 64'd0; // Combinational read port

endmodule