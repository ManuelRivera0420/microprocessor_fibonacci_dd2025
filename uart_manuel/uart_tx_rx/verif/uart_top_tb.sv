`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Manuel Enrique Rivera Acosta
// 
// Create Date: 10/28/2025 11:30:01 AM
// Design Name: 
// Module Name: uart_top_tb
//////////////////////////////////////////////////////////////////////////////////


module uart_top_tb();

localparam DATA_WIDTH = 8;

bit clk;
bit arst_n;
logic [3:0] baud_sel;
logic tx_done;
logic tx_start;
logic [DATA_WIDTH - 1 : 0] data_in;
logic [DATA_WIDTH - 1 : 0] data_out;

always #5ns clk = !clk;
assign #50ns arst_n = 1'b1;

// -----------------------------------------------------------
//   baud_sel     baud rate      parametro
// -----------------------------------------------------------
//    4'b0000       1200         BAUD_RATE_0
//    4'b0001       2400         BAUD_RATE_1
//    4'b0010       4800         BAUD_RATE_2
//    4'b0011       9600         BAUD_RATE_3
//    4'b0100      19200         BAUD_RATE_4
//    4'b0101      28800         BAUD_RATE_5
//    4'b0110      38400         BAUD_RATE_6
//    4'b0111      57600         BAUD_RATE_7
//    4'b1000      76800         BAUD_RATE_8
//    4'b1001     115200         BAUD_RATE_9
//    4'b1010     230400         BAUD_RATE_10
//    4'b1011     460800         BAUD_RATE_11
//    4'b1100     921600         BAUD_RATE_12
// -----------------------------------------------------------


initial begin
    baud_sel = 4'b0011; // START BY SELECTING THE BAUD RATE
    wait(arst_n);
    repeat(10) @(posedge clk); // WAIT 10 POSEDGE CLK TO MAKE SURE THAT THE SYSTEM DOESN'T TRANSMIT IF THE TX_START SIGNAL IS NOT SET TO 1
    @(posedge clk);
    tx_start <= 1'b1; // SET THE TX_START SIGNAL TO 1 TO BEGIN THE DATA TRANSMISSION
    std::randomize(data_in); // RANDOMIZE THE BYTE TO BE SENT BY THE TX - RX
    #1.05ms; // WAIT THE BYTE DURATION BASED ON THE BAUD RATE SELECTED TIMING
    $finish;
end

uart_top uart_top_i(
    .clk(clk),
    .arst_n(arst_n),
    .tx_start(tx_start),
    .data_in(data_in),
    .baud_sel(baud_sel),
    .tx_done(tx_done),
    .rx_done(rx_done),
    .data_out(data_out)
);

endmodule
