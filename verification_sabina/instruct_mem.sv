`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Laura Sabina Bañuelos Zendrero
// 
// Create Date: 27.11.2025 10:29:00
// Module Name: instruct_mem
// Project Name: 
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruct_mem(
    input  logic clk,
    input  logic arst_n,
    input  logic [7:0] data_uart,
    input  logic [5:0] pc,
    output logic [31:0] instructtion
    );
    
    // READ RAM ----------------------
    logic rden;
    logic [5:0] count;
    logic [31:0] data;
    
    // WRITE RAM ---------------------
    logic wren;
    logic [5:0] wraddr;
    logic [7:0] wrdata;
    
    //STATE RESGISTERS----------------
    logic [2:0] state;
        
    // STATES--------------------------
    localparam S0_write_mem = 3'b00;
    localparam S1_done = 3'b01;
    localparam S2_read_mem = 3'b10;
    
    ram_instruct ram(.rdaddr(count),.clk(clk),.rddata(data),.rden(rden),.wren(wren),.wraddr(wraddr),.wrdata(wrdata));
    
    
    always@(posedge clk, negedge arst_n) begin
        if(!arst_n) begin
            count <= 0; instructtion <= 32'b0; state <= S0_write_mem;  
            rden <= 1'b0; wren <= 1'b1;
        end 
        
        if(rden) begin
            count <= pc+3; state <= S2_read_mem; 
            wren <= 1'b0;
        end 
             
            case (state)
                
                S0_write_mem: begin
                    wraddr <= count;
                    wrdata <= data_uart;
                    count <= count == 10 ? 0 : count +1;
                    state <= count == 10 ? S1_done : S0_write_mem;
                end
                
                S1_done: begin
                    state <= S1_done;
                end
                
                S2_read_mem: begin
                    wraddr <= count;
                    instructtion <= data;
                    state <= S1_done;   
                    count <= count == pc ? 0 : count - 1;
                    state <= count == pc ? S1_done : S2_read_mem; 
                end
                
                
            endcase
        end
endmodule 