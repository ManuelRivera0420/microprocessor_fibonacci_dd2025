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
output logic enable,
output logic [DATA_WIDTH - 1 : 0] data_out
);

localparam BIT_SAMPLING = 15;
localparam HALFBIT_SAMPLING = 7;

logic [4:0] nbits;
logic [4:0] nbits_next;
logic [4:0] oversampling_count;
logic [4:0] oversampling_count_next;
logic [DATA_WIDTH - 1 : 0] data_out_reg;
logic [DATA_WIDTH - 1 : 0] data_out_reg_next;

typedef enum logic [2:0] {IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011} state_type;

state_type state_reg, state_next;

always_ff @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        state_reg <= IDLE;
    end else begin
        oversampling_count <= oversampling_count_next;
        state_reg <= state_next;
        nbits <= nbits_next;
        data_out_reg <= data_out_reg_next;
    end
end

always_comb begin
    case(state_reg)
        IDLE: begin
            enable = 1'b0;
            rx_done = 1'b0;
            oversampling_count_next = '0;
            nbits_next = '0;
            if(!rx) begin
                oversampling_count_next = '0;
                state_next = START;
                data_out_reg_next = '0;
                enable = 1'b1;
            end else begin
                state_next = IDLE;
            end 
        end
        START: begin
            enable = 1'b1;
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING) begin
                    state_next = DATA;
                    oversampling_count_next = '0;
                end else begin
                    oversampling_count_next = oversampling_count + 1;
                    state_next = START;
                end
            end else begin
                state_next = START;
            end
        end
        DATA: begin
            enable = 1'b1;
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING ) begin 
                    data_out_reg_next = {rx, data_out_reg[DATA_WIDTH - 1 : 1]};
                    oversampling_count_next = '0;
                    if(nbits == (DATA_WIDTH - 1)) begin
                        state_next = STOP;
                    end else begin
                        nbits_next = nbits + 1;
                    end
                end else begin
                    oversampling_count_next = oversampling_count + 1;
                    state_next = DATA;                    
                end
            end
        end
        STOP: begin
            enable = 1'b1;
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING) begin
                    rx_done = 1'b1;
                    state_next = IDLE;
                end else begin
                    oversampling_count_next = oversampling_count + 1;
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
