`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 07:43:00 PM
// Design Name: 
// Module Name: ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_s(
    input logic clk,
    input logic wren,
    input logic [9:0] wraddr,
    input logic [31:0] wrdata,
    input logic rden,
    input logic [9:0] rdaddr,
    output logic [31:0] rddata
    );

    logic [7:0] mem [1024]; // Array - memory
	 
	 initial begin
    for (int i = 0; i < 1024; i++) begin
        mem[i] = '0;
    end
	 end

    always_ff@(posedge clk) begin // Writing port
        if(wren)
            mem[wraddr] <= wrdata [7:0];
				mem[wraddr +1] <= wrdata [15:8];
				mem[wraddr +2] <= wrdata [23:16];
				mem[wraddr +3] <= wrdata [31:24];
    end

    always_ff@(posedge clk) begin // Writing port
        rddata <= rden ? {mem[rdaddr+3],mem[rdaddr+2],mem[rdaddr+1],mem[rdaddr]} : '0;
    end
    //assign rddata = rden ? mem[rdaddr] : 64'd0; // Combinational read port

endmodule
