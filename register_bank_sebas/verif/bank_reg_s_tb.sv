`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2025 16:23:01
// Design Name: 
// Module Name: bank_reg_s_tb
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


module bank_reg_s_tb();
// Parameter declaration
parameter NUM_TESTS = 10000;
// Variables declaration
bit clk;
bit arst_n;
bit write_en;
logic [4:0] read_dir1;
logic [4:0] read_dir2;
logic [4:0] write_dir;
logic [31:0] write_data;
logic [31:0] read_data1;
logic [31:0] read_data2;

bank_reg_s prf_i(
    .clk (clk),                    //Clock signal
    .arst_n (arst_n),              //Reset signal
    .write_en (write_en),          //Write enable signal
    .read_dir1 (read_dir1),        //Read direction 1
    .read_dir2 (read_dir2),        //Read direction 2
    .write_dir (write_dir),        //Write direction
    .write_data (write_data),      //Data to write
    .read_data1 (read_data1),      //Readed Data 1
    .read_data2 (read_data2)       //Readed Data 2
    );

    // Logic to generate stimulus
    always #5ns clk = !clk;
    always #80ns arst_n = !arst_n; // assign a one to arst_n after 20ns
    always #300ns write_en = !write_en;
    // Initial procedural block that is executed at t=0
    // This starts a concurrent process
    initial begin
        clk <= 1'b0; // Initialize enable to zero
        arst_n <= 1'b1; // Initialize enable to high
        read_dir1 <= 1'b0;
        read_dir2 <= 1'b0;
        write_dir <= 1'b0;
        write_data <= 1'b0;

        repeat(NUM_TESTS) begin
            @(posedge clk);
            std::randomize(write_data);
            std::randomize(write_dir);
            read_dir1 <= write_dir;
            std::randomize(read_dir2);
            #20ns;
        end

        #1us;
        $finish;
    end

endmodule
