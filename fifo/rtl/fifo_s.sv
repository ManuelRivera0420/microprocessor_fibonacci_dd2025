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
    input logic clk,                            //Signal of clock
    input logic arst_n,                         //Signal of reset
    input logic wren,                           //Signal of write enable
    input logic [DATA_WIDTH - 1:0] wdata,       //Paralell inputs of data to write
    input logic rden,                           //Signal of read enable
    output logic [DATA_WIDTH - 1:0] rdata,      //Paralell outputs of readed data
    output logic full,                          //Signal that indicates full storange
    output logic empty                          //Signal that indicates empty storange
);

    logic early_empty;                          //Temporal signal that indicates the posibility of empty storange in the next iteration
    logic early_full;                           //Temporal signal that indicates the posibility of full storange in the next iteration
    logic [DATA_WIDTH - 1 : 0] mem [32];        //Memory declaration
    logic [$clog2(DATA_WIDTH - 1) : 0] wrptr;   //Selector of address to write data
    logic [$clog2(DATA_WIDTH - 1) : 0] rdptr;   //Selector of address to read data
    
    always_ff@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin                       //Condition of reset
            rdptr <= '0;                        //Set read address to 0
            wrptr <= '0;                        //Set write address to 0
            full <= 1'b0;                       //Set full to 0
            empty <= 1'b1;                      //Set empty to 1
        end else begin
            if(rden && (!empty))                //Condition to read data
                rdptr <= rdptr + 1'b1;          //Increases address of read in 1 unit
            if(wren && (!full)) begin           //Condition to write data
                mem[wrptr] <= wdata;            //Assignation of data in memory storange
                wrptr <= wrptr + 1'b1;          //Increases address of write in 1 unit
            end
            if(early_full)                      //Condition to set full
                full <= 1'b1;                   //Assignation of full to 1
            if(rden)                            //Condition to set not full
                full <= 1'b0;                   //Assignation of full to 0
            if(early_empty)                     //Condition to set empty
                empty <= 1'b1;                  //Asignation of empty to 1
            if(wren)                            //Condition to set not empty
                empty <= 1'b0;                  //Assignation of empty to 0
        end
    end

    assign rdata = rden ? mem[rdptr] : '0;                              //Assignation of readed data
    assign early_full = (wrptr == (rdptr - 1'b1)) && wren && (!rden);   //If write address is one step to be the same than read address, and write is enable and read is not enable, then early_full is set
    assign early_empty = (rdptr == (wrptr - 1'b1)) && rden && (!wren);  //If read address is one step to be the same than write address, and read is enable and write is not enable, then early_empty is set 

    // Conditions to set full
    // 1.- wrptr === rdptr
    // 2.- $past(wrptr) == rdptr - 1
    // 3.- wren && (!rden)
    
endmodule
