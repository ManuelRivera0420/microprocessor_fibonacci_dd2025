`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 06:21:14 PM
// Design Name: 
// Module Name: sfifo
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

module fifo_s #(parameter DATA_WIDTH = 32)(
    input logic clk,
    input logic arst_n,
    input logic wren,
    input logic [DATA_WIDTH - 1:0] wdata,
    input logic rden,
    output logic [DATA_WIDTH - 1:0] rdata,
    output logic full,
    output logic empty
);

    logic early_empty;
    logic early_full;
    logic [DATA_WIDTH - 1 : 0] mem [16]; // Memory declaration
    logic [$clog2(DATA_WIDTH - 1) : 0] wrptr;
    logic [$clog2(DATA_WIDTH - 1) : 0] rdptr;
    
    always_ff@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin
            rdptr <= '0;
        end else begin
            if(rden && (!empty))
                rdptr <= rdptr + 1'b1;
        end
    end

    always_ff@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin
            wrptr <= '0;
        end else begin
            if(wren && (!full))
                wrptr <= wrptr + 1'b1;
        end
    end

    always_ff@(posedge clk) begin // Writing port
        if(wren && (!full))
            mem[wrptr] <= wdata;
    end

    assign rdata = rden ? mem[rdptr] : '0;
    assign early_full = (wrptr == (rdptr - 1'b1)) && wren && (!rden);
    assign early_empty = (rdptr == (wrptr - 1'b1)) && rden && (!wren);

    always_ff@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin
            full <= 1'b0;
        end else begin
            if(early_full)
                full <= 1'b1;
            if(rden)
                full <= 1'b0;
        end
    end

    always_ff@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin
            empty <= 1'b1;
        end else begin
            if(early_empty)
                empty <= 1'b1;
            if(wren)
                empty <= 1'b0;
        end
    end
    
    
    // Conditions to set full
    // 1.- wrptr === rdptr
    // 2.- $past(wrptr) == rdptr - 1
    // 3.- wren && (!rden)
    

endmodule
