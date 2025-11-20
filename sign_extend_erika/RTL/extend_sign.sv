`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2025 21:05:12
// Design Name: 
// Module Name: extend_sign
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



module extend_sign #(parameter WIDTH_IN  = 12,parameter WIDTH_OUT = 32)(
    input  logic [WIDTH_IN-1:0] imm_in,
    output logic [WIDTH_OUT-1:0] imm_out
);
    localparam WIDTH_EXTEND = WIDTH_OUT - WIDTH_IN;
    assign imm_out = {{WIDTH_EXTEND{imm_in[ WIDTH_IN-1]}}, imm_in};
endmodule