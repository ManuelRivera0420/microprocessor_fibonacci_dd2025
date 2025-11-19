`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 11:30:01 AM
// Design Name: 
// Module Name: uart_top_tb
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module uart_top_tb();

localparam DATA_WIDTH = 8;

bit clk;
bit arst_n;
logic [3:0] baud_sel;
logic [DATA_WIDTH - 1 : 0] data_out;
logic rx_done;
logic rx;

always #10ns clk = !clk;
assign #50ns arst_n = 1'b1;

initial begin
    repeat(10) @(posedge clk);
    @(posedge clk);
    rx <= 1'b0;
    #1ms;
    rx <= 1'b1;
    #10ms;
    $finish;
end

initial begin
    baud_sel <= 4'b1001;
end

receiver receiver_i(
    .clk(clk),
    .arst_n(arst_n),
    .tick(tick),
    .rx(tx),
    .rx_done(rx_done),
    .data_out(data_out)
);

baud_rate_generator baud_rate_generator_i(
.clk(clk),
.arst_n(arst_n),
.baud_sel(baud_sel),
.tick(tick)
);

endmodule
