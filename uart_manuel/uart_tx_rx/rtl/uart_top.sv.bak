`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Manuel Enrique Rivera Acosta
// 
// Create Date: 10/28/2025 12:14:17 PM
// Design Name: 
// Module Name: uart_top
//////////////////////////////////////////////////////////////////////////////////


module uart_top #(parameter DATA_WIDTH = 8)(
    input logic clk,
    input logic arst_n,
    input logic tx_start,
    input logic [DATA_WIDTH - 1 : 0] data_in,
    input logic [3:0] baud_sel,
    output logic tx_done,
    output logic [DATA_WIDTH - 1 : 0] data_out,
    output logic rx_done
);

logic tick;
logic tx;

baud_rate_generator baud_rate_generator_i(
    .clk(clk),
    .arst_n(arst_n),
    .tick(tick),
    .baud_sel(baud_sel)
);

transmitter transmitter_i(
   .clk(clk),
   .arst_n(arst_n),
   .data_in(data_in),
   .tick(tick),
   .tx_start(tx_start),
   .tx(tx),
   .tx_done(tx_done)
);
 
receiver receiver_i(
.clk(clk),
.arst_n(arst_n),
.tick(tick),
.rx(tx), // RX CONNECTED TO THE TX FROM THE TRANSMITTER MODULE
.rx_done(rx_done),
.data_out(data_out)
);

endmodule
