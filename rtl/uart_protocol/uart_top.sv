`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Manuel Enrique Rivera Acosta
// 
// Create Date: 10/28/2025 12:14:17 PM
// Design Name: 
// Module Name: uart_top
//////////////////////////////////////////////////////////////////////////////////


module uart_top #(parameter DATA_WIDTH = 32, BYTE_WIDTH = 8)(
    input logic clk,
    input logic arst_n,
	 input logic rx,
    input logic [3:0] baud_sel,
	 input logic [9:0] rdaddr,
    output logic [DATA_WIDTH - 1 : 0] data_out,
    output logic rx_done,
	 output logic [((DATA_WIDTH / 4) * 7) - 1 : 0] display,
	 output logic [DATA_WIDTH - 1 : 0] read_data,
	 output logic [2:0] state,
	 output logic prog_rdy
);

logic tick;
logic [7:0] uart_byte;
logic [9:0] uart_addr;
logic inst_rdy;


shift_register_fsm sf_i(
    .clk (clk),
    .arst_n (arst_n),
    .w_en (rx_done), // input write enable coming from uart rx_done
    .data_in (uart_byte), // data_in coming from uart data_out port
    .data_out (data_out), // data out to be written in the program memory after receiving 4 bytes from uart
    .wr_addr (uart_addr), // write addres for the memory
    .inst_rdy (inst_rdy), // flag to indicate that a instruction is ready, this is the write enable for the memory
	 .state (state),
    .prog_rdy (prog_rdy)  // flag to indicate that the program has been initialized into the memory
);

ram_s rm_i(
    .clk (clk),
    .wren (inst_rdy),
    .wraddr (uart_addr),
    .wrdata (data_out),
    .rden (1'b1),
    .rdaddr (rdaddr),
    .rddata (read_data)
    );


baud_rate_generator baud_rate_generator_i(
    .clk(clk),
    .arst_n(arst_n),
    .tick(tick),
    .baud_sel(baud_sel)
);
/*
transmitter transmitter_i(
   .clk(clk),
   .arst_n(arst_n),
   .data_in(data_in),
   .tick(tick),
   .tx_start(tx_start),
   .tx(tx),
   .tx_done(tx_done)
);
 */
 
display_7_segments #(.DATA_WIDTH(DATA_WIDTH)) dsp_i(
    .data_in (read_data),
    .display (display)
);
 
receiver receiver_i(
.clk(clk),
.arst_n(arst_n),
.tick(tick),
.rx(rx), // RX CONNECTED TO THE TX FROM THE TRANSMITTER MODULE
.rx_done(rx_done),
.data_out(uart_byte)
);


endmodule
