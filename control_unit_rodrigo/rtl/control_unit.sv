`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 14.11.2025 18:24:51
// Design Name: 
// Module Name: control_unit
//////////////////////////////////////////////////////////////////////////////////

// TEST REPO
module control_unit(
	input logic [6:0] opcode,  //instrucctions [6:0]
	input logic [2:0] funct_3, //instructions [14:12]
	input logic [6:0] func_7, //instructions [31:25]
	output logic regwrite,
	output logic memread,
	output logic memwrite,
	output logic memtoreg,
	output logic alusrc,
	output logic branch,
	output logic jump,
	output logic [1:0] alucontrol
);
	//Define the instructions 
	//`include "../../defines.svh"
	localparam OPCODE_RTYPE = 7'b0110011;
	localparam OPCODE_ITYPE = 7'b0010011;
	localparam OPCODE_BTYPE = 7'b1100011;
	localparam OPCODE_JTYPE = 7'b1101111;
	//Define the intructions for ALU
	localparam ALU_ADD = 4'b0000;
	localparam ALU_SUB = 4'b0001;
	
    
	always_comb begin 
		
	end

endmodule
