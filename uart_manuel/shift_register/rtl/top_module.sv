`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 10:38:01 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module top_module #(parameter DATA_WIDTH = 32, parameter INPUT_BYTE = 8, parameter N_INSTRUCTIONS = 10)(
    input logic clk,
    input logic arst_n,
    input logic w_en,
    input logic [INPUT_BYTE - 1 : 0] data_in,
    output logic [DATA_WIDTH - 1 : 0] data_out 
);
    
logic [DATA_WIDTH - 1 : 0] data;
logic [INPUT_BYTE - 1 : 0] wr_addr;
logic prog_rdy;
logic inst_rdy;
logic [DATA_WIDTH - 1 : 0] rd;


shift_register_fsm shift_register_fsm_i(
.clk(clk),
.arst_n(arst_n),
.w_en(w_en),
.data_in(data_in),
.data_out(data),
.prog_rdy(prog_rdy),
.wr_addr(wr_addr),
.inst_rdy(inst_rdy)
);

instruction_memory instruction_memory_i(
.clk(clk),
.a('0),       
.rd(rd),      
.data_in(data),
.dir(wr_addr),     
.we(inst_rdy)        
);

assign data_out = data;

endmodule
