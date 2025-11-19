`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 11:14:06 AM
// Design Name: 
// Module Name: baud_rate_generator
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module baud_rate_generator #(parameter CLK_FREQ = 50_000_000)(
input logic clk,
input logic arst_n,
input logic [3:0] baud_sel,
output logic tick
);

localparam BAUD_RATE_0 = 1200;
localparam BAUD_RATE_1 = 2400;
localparam BAUD_RATE_2 = 4800;
localparam BAUD_RATE_3 = 9600;
localparam BAUD_RATE_4 = 19200;
localparam BAUD_RATE_5 = 28800;
localparam BAUD_RATE_6 = 38400;
localparam BAUD_RATE_7 = 57600;
localparam BAUD_RATE_8 = 76800;
localparam BAUD_RATE_9 = 115200;
localparam BAUD_RATE_10 = 230400;
localparam BAUD_RATE_11 = 460800;
localparam BAUD_RATE_12 = 921600;

logic [15:0] counter_max;
logic [15:0] counter;

always_comb begin
    case(baud_sel)
        4'b0000: counter_max = (CLK_FREQ / BAUD_RATE_0);
        4'b0001: counter_max = (CLK_FREQ / BAUD_RATE_1); 
        4'b0010: counter_max = (CLK_FREQ / BAUD_RATE_2); 
        4'b0011: counter_max = (CLK_FREQ / BAUD_RATE_3); 
        4'b0100: counter_max = (CLK_FREQ / BAUD_RATE_4); 
        4'b0101: counter_max = (CLK_FREQ / BAUD_RATE_5); 
        4'b0110: counter_max = (CLK_FREQ / BAUD_RATE_6); 
        4'b0111: counter_max = (CLK_FREQ / BAUD_RATE_7); 
        4'b1000: counter_max = (CLK_FREQ / BAUD_RATE_8); 
        4'b1001: counter_max = (CLK_FREQ / BAUD_RATE_9); 
        4'b1010: counter_max = (CLK_FREQ / BAUD_RATE_10); 
        4'b1011: counter_max = (CLK_FREQ / BAUD_RATE_11); 
        4'b1100: counter_max = (CLK_FREQ / BAUD_RATE_12); 
    endcase
end

always_ff @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        tick <= 1'b0;
        counter <= '0;
    end else begin
        if(counter == counter_max) begin
            counter <= '0;
            tick <= 1'b1;
        end else begin
            counter <= counter + 1;
            tick <= 1'b0;
        end
    end
end

endmodule
