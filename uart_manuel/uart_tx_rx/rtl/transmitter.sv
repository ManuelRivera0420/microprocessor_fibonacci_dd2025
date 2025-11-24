`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Manuel Enrique Rivera Acosta
// 
// Create Date: 10/28/2025 12:38:11 PM
// Design Name: 
// Module Name: transmitter
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module transmitter #(parameter DATA_WIDTH = 8)(
    input logic clk,
    input logic arst_n,
    input logic [DATA_WIDTH - 1 : 0] data_in, // DATA_IN TO BE SENT TO THE RECEIVER MODULE BIT BY BIT THROUGH THE TX
    input logic tick, // TICK COMING FROM THE BAUD RATE GENERATOR
    input logic tx_start, // TX_START SIGNAL TO BEGIN THE BYTE TRANSMISSION
    output logic tx, // SERIAL OUTPUT BIT TO TRANSMIT INTO THE RECEIVER RX INPUT SIGNAL
    output logic tx_done // DONE SIGNAL INDICATING THAT THE BYTE HAS BEEN SENT
);

localparam BIT_SAMPLING = 16;
localparam HALFBIT_SAMPLING = 8;

logic [DATA_WIDTH - 1 : 0] shifted_data;
logic [DATA_WIDTH - 1 : 0] shifted_data_next;

logic [4:0] nbits;
logic [4:0] nbits_next;

logic [4:0] oversampling_count;
logic [4:0] oversampling_count_next;

typedef enum {IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011} state_type;

state_type state_reg, state_next;

always_ff @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        state_reg <= IDLE;
    end else begin
        state_reg <= state_next;
        nbits <= nbits_next;
        oversampling_count <= oversampling_count_next;
        shifted_data <= shifted_data_next;
    end
end

always_comb begin
    case(state_reg)
        IDLE: begin
            tx_done = 1'b0;
            nbits_next = '0;
            tx = 1'b1;
            if(tx_start) begin 
                oversampling_count_next = '0;
                shifted_data_next = data_in;
                tx = 1'b0;
                state_next = START;
            end else begin
                state_next = IDLE;
            end
        end
        START: begin
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING - 1) begin
                    oversampling_count_next = '0;
                    state_next = DATA;             
                end else begin
                    oversampling_count_next = oversampling_count + 1;
                end
            end
        end
        DATA: begin
            tx = shifted_data[0];
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING - 1) begin
                    shifted_data_next = {1'b0, shifted_data[7:1]};
                    oversampling_count_next = '0;
                    if(nbits == DATA_WIDTH - 1) begin
                        state_next = STOP;
                    end else begin
                        nbits_next = nbits + 1'b1;
                    end
                end else begin
                    state_next = DATA;
                    oversampling_count_next = oversampling_count + 1;
                end
            end
        end
        STOP: begin
            tx = 1'b1;
            if(tick) begin
                if(oversampling_count == BIT_SAMPLING - 1) begin
                    tx_done = 1'b1;
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

endmodule
