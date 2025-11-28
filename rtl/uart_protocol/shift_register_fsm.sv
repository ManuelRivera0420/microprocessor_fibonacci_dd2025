`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 04:36:24 PM
// Design Name: 
// Module Name: shift_register_fsm
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module shift_register_fsm#(parameter DATA_WIDTH = 32, parameter INPUT_BYTE = 8, parameter ADDR_WIDTH = 10)(
    input logic clk,
    input logic arst_n,
    input logic w_en, // input write enable coming from uart rx_done
    input logic [INPUT_BYTE - 1 : 0] data_in, // data_in coming from uart data_out port
    output logic [DATA_WIDTH - 1 : 0] data_out, // data out to be written in the program memory after receiving 4 bytes from uart
    output logic [ADDR_WIDTH - 1 : 0] wr_addr, // write addres for the memory
    output logic inst_rdy, // flag to indicate that a instruction is ready, this is the write enable for the memory
	 output logic [2:0] state,
    output logic prog_rdy  // flag to indicate that the program has been initialized into the memory
);

// internal counters 
logic [INPUT_BYTE - 1 : 0] n_of_instructions;
logic [INPUT_BYTE - 1 : 0] n_of_instructions_next;

logic [ADDR_WIDTH - 1 : 0] instruction_counter;
logic [ADDR_WIDTH - 1 : 0] instruction_counter_next;

logic [DATA_WIDTH - 1 : 0] temp_data_out;
logic [DATA_WIDTH - 1 : 0] temp_data_out_next;

logic [INPUT_BYTE - 1 : 0] received_byte;

// states for the fsm
typedef enum logic [2:0]{
    WAIT_PARAMS = 3'b000,
    WAIT_BYTE0 = 3'b010,
    WAIT_BYTE1 = 3'b011,
    WAIT_BYTE2 = 3'b100,
    WAIT_BYTE3 = 3'b101,        
    WRITE_INSTRUCTION = 3'b110,
    DONE = 3'b111
} state_type;

state_type state_reg, state_next;

// reset all the signals and assign the next state sequential logic
always_ff@(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
        state_reg <= WAIT_PARAMS;
        instruction_counter <= '0;
        n_of_instructions <= '0;
        temp_data_out <= '0;
    end else begin
        state_reg <= state_next;
        instruction_counter <= instruction_counter_next;
        n_of_instructions <= n_of_instructions_next;
        temp_data_out <= temp_data_out_next;
    end
end

always_comb begin
    prog_rdy = 1'b0; // flag for program initialized set to 0
    n_of_instructions_next = n_of_instructions; // default value
    state_next = state_reg; // default state for state_next
    instruction_counter_next = instruction_counter; // default value
    temp_data_out_next = temp_data_out; // default value
    received_byte = data_in; // default value
    
    case(state_reg)
    
        WAIT_PARAMS: begin // receive a byte from the uart to define the number of instructions to write into the memory
            inst_rdy = 1'b0;
            prog_rdy = 1'b0;
            if(w_en) begin
                n_of_instructions_next = data_in;
                state_next = WAIT_BYTE0;
            end else begin
                n_of_instructions_next = n_of_instructions;
            end
        end
    
        WAIT_BYTE0: begin // receive the 1st byte of the instruction
            inst_rdy = 1'b0;
            prog_rdy = 1'b0;
            if(w_en) begin
                temp_data_out_next[7:0] = data_in;
                state_next = WAIT_BYTE1;
            end else begin
                received_byte = received_byte;
            end 
        end

        WAIT_BYTE1: begin // receive the 2nd byte of the instruction
            inst_rdy = 1'b0;
            prog_rdy = 1'b0;
            if(w_en) begin
                temp_data_out_next[15:8] = data_in;
                state_next = WAIT_BYTE2;
            end else begin
                received_byte = received_byte;
            end 
        end
        
        WAIT_BYTE2: begin // receive the 3rd byte of the instruction
            inst_rdy = 1'b0;
            prog_rdy = 1'b0;
            if(w_en) begin
                temp_data_out_next[23:16] = data_in;
                state_next = WAIT_BYTE3;
            end else begin
                received_byte = received_byte;
            end 
        end
        
        WAIT_BYTE3: begin // receive the 4th and last byte of the instruction
            inst_rdy = 1'b0;
            prog_rdy = 1'b0;
            if(w_en) begin
                temp_data_out_next[31:24] = data_in;
                state_next = WRITE_INSTRUCTION;
            end else begin
                received_byte = received_byte;
            end 
        end
                                
        WRITE_INSTRUCTION: begin // state to write instruction once the shifter has received 4 bytes = 32 bits instruction
            prog_rdy = 1'b0;
            inst_rdy = 1'b1;
            if(instruction_counter == (n_of_instructions - 1) * 4) begin 
                state_next = DONE;
            end else begin
                instruction_counter_next = instruction_counter + 3'd4;
                state_next = WAIT_BYTE0;
            end
        end
        
        DONE: begin // done state to set program ready flag to 1
            prog_rdy = 1'b1;
            inst_rdy = 1'b0;
            temp_data_out_next = '0;
            state_next = WAIT_BYTE0;
        end
        
    endcase
end

assign data_out = temp_data_out;
assign wr_addr = instruction_counter;
assign state = state_reg;


endmodule
