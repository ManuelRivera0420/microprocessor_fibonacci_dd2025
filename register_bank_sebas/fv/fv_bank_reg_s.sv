module fv_bank_reg_s #(parameter DIR_WIDTH = 5, parameter DATA_WIDTH = 32) (
	input logic clk, //Clock signal
  input logic arst_n, //Reset signal
  input logic write_en,  //Write enable signal
  input logic [DIR_WIDTH - 1:0] read_dir1, //Read direction 1
  input logic [DIR_WIDTH - 1:0] read_dir2, //Read direction 2
  input logic [DIR_WIDTH - 1:0] write_dir, //Write direction
  input logic [DATA_WIDTH - 1:0] write_data, //Data to write
  input logic [DATA_WIDTH - 1:0] read_data1, //Readed Data 1
  input logic [DATA_WIDTH - 1:0] read_data2  //Readed Data 2
);

	ast_data_written: assert property (@(posedge clk) disable iff (!arst_n) write_en && (write_dir != 5'b00000) |=> bank_reg_s.prf[$past(write_dir)] == $past(write_data));
  ast_x0_always_zero: assert property (@(posedge clk) disable iff (!arst_n) 1'b1 |-> bank_reg_s.prf[5'b00000] == '0);
  //read_data1_equal_write_data: assert property (@(posedge clk) disable iff (!arst_n) (read_data1 == write_data) |-> (read_dir1 == write_dir));
  //read_data_following_pointer: assert property (@(posedge clk) disable iff (!arst_n) read_data1 == bank_reg_s.prf[read_dir1] |-> sync_accept_on(read_dir1 == write_dir) (read_dir1 != write_dir));
  read_data1_equal_write_data: assert property (@(posedge clk) disable iff (!arst_n) (read_dir1 == write_dir) |-> (read_data1 == write_data));
  read_data_following_pointer: assert property (@(posedge clk) disable iff (!arst_n) (read_dir1 != write_dir) |-> (read_data1 == bank_reg_s.prf[read_dir1]));

endmodule

bind bank_reg_s fv_bank_reg_s fv_bank_reg_s_i(.*);
