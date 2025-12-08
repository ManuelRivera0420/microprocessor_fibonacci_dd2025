module fibonacci_result_fsm #(parameter DATA_WIDTH = 32)(
	input logic clk,
	input logic arst_n,
	input logic [DATA_WIDTH - 1 : 0] fib_in,
	input logic new_fib_res,
	input logic start,
	input logic prog_ack,
	output logic [DATA_WIDTH - 1 : 0] fib_out,
	output logic w_en_res,
	output logic fib_written
);

typedef enum logic [1:0]
{
IDLE = 2'b00,
GET_FIB = 2'b01,
WRITE_FIB = 2'b10,
FIB_DONE = 2'b11
} state;

state state_reg, state_next;

logic [DATA_WIDTH - 1 : 0] fib_data_temp;
logic [DATA_WIDTH - 1 : 0] fib_data_temp_next;

always_ff @(posedge clk or negedge arst_n) begin
	if(!arst_n) begin
		state_reg <= IDLE;
	end else begin
		state_reg <= state_next;
		fib_data_temp <= fib_data_temp_next;
	end
end

always_comb begin
	fib_data_temp_next = fib_data_temp;
	state_next = state_reg;
	case(state_reg)
	
		IDLE: begin
			if(!start) begin
				state_next = GET_FIB;
			end
		end
		
		GET_FIB: begin
			if(new_fib_res) begin
				fib_data_temp_next = fib_in;
				state_next = WRITE_FIB;
			end else begin
				state_next = GET_FIB;
			end
		end
		
		WRITE_FIB: begin
			if(!prog_ack) begin
				state_next = GET_FIB;
			end else begin
				state_next = FIB_DONE;
			end
		end
		
		FIB_DONE: begin
			state_next = IDLE;
		end
		
	endcase
end

assign fib_written = (state_reg == FIB_DONE);
assign w_en_res = (state_reg == WRITE_FIB);
assign fib_out = fib_data_temp;


endmodule