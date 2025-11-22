`timescale 1ns / 1ps

module shift_register_tb();

parameter DATA_WIDTH = 32;
parameter INPUT_BYTE = 8;
parameter N_INSTRUCTIONS = 8;

bit clk;
bit arst_n;
logic w_en;
logic [INPUT_BYTE - 1 : 0] data_in;
logic [DATA_WIDTH - 1 : 0] data_out;

logic [7:0] n_instructions;

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


initial begin
    w_en = 1'b0;
    data_in = '0;

    wait(arst_n);
    
    @(posedge clk);
    data_in = 8'd10;
    n_instructions = data_in;
    w_en = 1'b1;
    @(posedge clk);
    w_en = 1'b0;

    for (int i = 0; i < n_instructions; i++) begin
        write_instruction(instr_mem[i]);
    end
    w_en = 1'b0;
end

initial begin
    #100ms;
    $finish;
end



top_module #(.N_INSTRUCTIONS(N_INSTRUCTIONS)) top_module(
.clk(clk),
.arst_n(arst_n),
.w_en(w_en),
.data_in(data_in),
.data_out(data_out)
);

endmodule