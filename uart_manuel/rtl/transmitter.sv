`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 12:38:11 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter #(parameter DATA_WIDTH = 8)(
    input logic clk,
    input logic arst_n,
    input logic [DATA_WIDTH - 1 : 0] data_in,
    input logic tick,
    input logic tx_start,
    output logic tx,
    output logic tx_done
);

localparam BIT_SAMPLING = 16;
localparam HALFBIT_SAMPLING = 7;

logic [DATA_WIDTH - 1 : 0] shifted_data;
logic [4:0] nbits;
logic [4:0] oversampling_count;

typedef enum {IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011} state_type;

state_type state_reg, state_next;

always_ff @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        state_reg = IDLE;
    end else begin
        state_reg = state_next;
    end
end

always_comb begin
    case(state_reg)
        IDLE: begin
            tx_done = 1'b0;
            nbits = '0;
            tx = 1'b0;
            if(tx_start) begin 
                oversampling_count = '0;
                shifted_data = data_in;
                state_next = START;
            end else begin
                state_next = IDLE;
            end
        end
        START: begin
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING) begin
                    oversampling_count = '0;
                    state_next = DATA;             
                end else begin
                    oversampling_count = oversampling_count + 1;
                end
            end
        end
        DATA: begin
            tx = shifted_data[0];
            if(tick) begin
                if(nbits == (DATA_WIDTH - 1)) begin
                    state_next = STOP;
                    oversampling_count = '0;
                end else begin
                    if(oversampling_count == BIT_SAMPLING) begin
                        shifted_data = {1'b1, shifted_data[7:1]};
                        oversampling_count = '0;
                        nbits = nbits + 1;
                        state_next = DATA;
                    end else begin
                        state_next = DATA;
                        oversampling_count = oversampling_count + 1;
                    end
                end
            end
        end
        STOP: begin
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING) begin
                    tx_done = 1'b1;
                    state_next = IDLE;
                end else begin
                    oversampling_count = oversampling_count + 1;
                    state_next = STOP;
                end
            end else begin
                state_next = STOP;
            end
        end
    endcase
end

endmodule
