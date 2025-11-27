`timescale 1ns / 1ps

module top_communication_tb();

parameter DATA_WIDTH = 32;
parameter BYTE_WIDTH = 8;

bit clk;
bit arst_n;
logic [3:0] baud_sel;
logic rx;
logic [DATA_WIDTH - 1 : 0] data_out;
logic [((DATA_WIDTH / 4) * 7) - 1 : 0] display;
logic prog_rdy;

always #5ns clk = !clk;
assign #30ns arst_n = 1'b1;

logic [31:0] instr_mem [0:9] = '{
    32'h00000513, // I-type
    32'h00100593, // I-type
    32'h00A00613, // I-type
    32'h00060C63, // B-type
    32'h00B502B3, // R-type
    32'h00B00533, // R-type
    32'h005005B3, // R-type
    32'hFFF60613, // I-type
    32'hFEDFF06F, // J-type largo
    32'h0000006F  // JAL
};

/*
task automatic write_instruction(input logic [31:0] instr);
    logic [7:0] b0, b1, b2, b3;

    b3 = instr[7:0];
    b2 = instr[15:8];
    b1 = instr[23:16];
    b0 = instr[31:24];

    // BYTE 0
    @(posedge clk);
    data_in = b0; 
    @(posedge clk);
    w_en = 1'b1;
    @(posedge clk); w_en = 1'b0; repeat(10) @(posedge clk);

    // BYTE 1
    @(posedge clk);
    data_in = b1; 
    @(posedge clk);
    w_en = 1'b1;
    @(posedge clk); w_en = 1'b0; repeat(10) @(posedge clk);

    // BYTE 2
    @(posedge clk);
    data_in = b2; 
    @(posedge clk);
    w_en = 1'b1;
    @(posedge clk); w_en = 1'b0; repeat(10) @(posedge clk);

    // BYTE 3
    @(posedge clk);
    data_in = b3; 
    @(posedge clk);
    w_en = 1'b1;
    @(posedge clk); w_en = 1'b0; repeat(10) @(posedge clk);
endtask
*/


initial begin
    baud_sel = 4'b0011;
    rx = 1'b1;
    repeat(50) begin
        repeat(10) @(posedge clk);
        rx = 1'b0;
<<<<<<< Updated upstream
        #120us;
        repeat(8) begin
            std::randomize(rx);
            #120us;
=======
        #106us;
        repeat(8) begin
            std::randomize(rx);
            #106us;
>>>>>>> Stashed changes
        end
        rx = 1'b1;
        #106us;
    end
end

initial begin
    #60ms;
    $finish;
end

top_communication top_communication_i(
.clk(clk),
.arst_n(arst_n),
.rx(rx),
.baud_sel(baud_sel),
.data_out(data_out),
.display(display),
.prog_rdy(prog_rdy)
);

/*
top_module top_module(
.clk(clk),
.arst_n(arst_n),
.w_en(w_en),
.data_in(data_in),
.data_out(data_out)
);
*/

endmodule