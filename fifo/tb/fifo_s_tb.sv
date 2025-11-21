`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 06:44:46 PM
// Design Name: 
// Module Name: sfifo_tb
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


module fifo_s_tb #(parameter DATA_WIDTH = 32)();

    localparam NUM_TESTS = 1000;
    bit clk;
    bit arst_n;
    logic wren;
    logic [7:0] uart_data;
    logic rden;
    logic [DATA_WIDTH - 1:0] rdata;
    logic full;
    logic empty;
    
    always #5ns clk = !clk;
    assign #15ns arst_n = 1'b1;
    
    task write_fifo();
        if(!full) begin
            wren <= 1'b1;
            std::randomize(uart_data);
            @(posedge clk);
        end
        wren <= 1'b0;
        @(posedge clk);
    endtask

    task read_fifo();
        if(!empty) begin
            rden <= 1'b1;
            @(posedge clk);
        end
        rden <= 1'b0;
        @(posedge clk);
    endtask
    
    initial begin
        wren <= 1'b0;
        rden <= 1'b0;
        uart_data <= '0;
        wait(arst_n);
        repeat(1) @(posedge clk);
        fork
        
            begin // Creates a thread for generate random writes
                repeat(NUM_TESTS) begin
                    randcase
                        1: write_fifo();
                        1: @(posedge clk);
                    endcase
                end
            end
            
            begin // Creates a thread for generate reads randomly
                repeat(NUM_TESTS) begin
                    randcase
                        1: read_fifo();
                        1: @(posedge clk);
                    endcase
                end
            end
        join

        repeat(10) @(posedge clk);
        $finish;
    end
    
    //empty_or_full_if_ptrs_equal: assert property (@(posedge clk) sfifo_i.wrptr == sfifo_i.rdptr |=> empty | full); 
    //wrptr_increment_if_write: assert property (@(posedge clk) wren |=> sfifo_i.wrptr == $past(sfifo_i.wrptr + 1));
    

    fifo_s sfifo_i(
        .clk(clk),
        .arst_n(arst_n),
        .wren(wren),
        .uart_data(uart_data),
        .rden(rden),
        .rdata(rdata),
        .full(full),
        .empty(empty)
    );

endmodule
