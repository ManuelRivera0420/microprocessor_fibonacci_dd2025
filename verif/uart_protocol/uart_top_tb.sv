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

bit clk;
bit arst_n;
logic [3:0] baud_sel;
logic rx;
logic rdaddr;
logic [DATA_WIDTH - 1 : 0] data_out;
logic [2 : 0] state;
logic [DATA_WIDTH - 1 : 0] read_data;
logic [((DATA_WIDTH / 4) * 7) - 1 : 0] display;
logic rx_done;
logic prog_rdy;
logic tx;
logic tx_done;
logic tx_start;

always #10ns clk = !clk;
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
    baud_sel = 4'b0011;
    repeat(100) begin
        rx = 1'b1;
        #250us;
        repeat(8) begin
            rx = 1'b0;
            #106us;
            std::randomize(rx);
            #106us;
            rx = 1'b1; 
        end
        #200us;
    end
end

uart_top uart_top_i(
    .clk(clk),
    .arst_n(arst_n),
    .rx(rx),
    .baud_sel(baud_sel),
    .rdaddr(rdaddr),
    .state(state),
    .prog_rdy(prog_rdy),
    .rx_done(rx_done),
    .data_out(data_out),
    .display(display),
    .read_data(display),
    .tx(tx),
    .tx_done(tx_done),
    .tx_start(tx_start)
);

endmodule

