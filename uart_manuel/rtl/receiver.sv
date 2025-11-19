`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 11:54:10 AM
// Design Name: 
// Module Name: receiver
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module receiver #(parameter DATA_WIDTH = 8)(
input logic clk,
input logic arst_n,
input logic tick,
input logic rx,
output logic rx_done,
output logic [DATA_WIDTH - 1 : 0] data_out
);

localparam BIT_SAMPLING = 16;
localparam HALFBIT_SAMPLING = 7;

logic [4:0] nbits;
logic [4:0] oversampling_count;
logic [DATA_WIDTH - 1 : 0] data_out_reg;

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
            rx_done = 1'b0;
            oversampling_count = '0;
            nbits = '0;
            if(tick) begin
                if(!rx) begin
                    state_next = START;
                end else begin
                    state_next = IDLE;
                end 
            end
        end
        START: begin
            data_out_reg = '0;
            if(tick) begin
                if(!rx) begin
                    if(oversampling_count == HALFBIT_SAMPLING) begin
                        state_next = DATA;
                        oversampling_count = '0;
                    end else begin
                        oversampling_count = oversampling_count + 1;
                        state_next = START;
                    end
                end
            end else begin
                state_next = START;
            end
        end
        DATA: begin
            if(tick) begin
                if(nbits == (DATA_WIDTH)) begin
                    state_next = STOP;
                end else begin
                    if(oversampling_count == BIT_SAMPLING) begin
                        data_out_reg = {rx, data_out_reg[DATA_WIDTH - 1 : 1]};
                        nbits = nbits + 1;
                        oversampling_count = '0;
                        state_next = DATA;
                    end else begin
                        oversampling_count = oversampling_count + 1;
                        state_next = DATA;
                    end
                end
            end
        end
        STOP: begin
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING) begin
                    rx_done = 1'b1;
                    state_next = IDLE;
                end else begin
                    rx_done = 1'b0;
                    oversampling_count = oversampling_count + 1;
                    state_next = STOP;
                end
            end else begin
                state_next = STOP;
            end
        end
    endcase
end

assign data_out = data_out_reg;

endmodule
