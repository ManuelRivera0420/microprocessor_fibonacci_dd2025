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
	output logic immrd;
	output logic [3:0] alucontrol
);
	//Define the instructions 
	//`include "../../defines.svh"
	localparam OPCODE_R_TYPE = 7'b0110011;
	localparam OPCODE_I_TYPE = 7'b0010011;
	localparam OPCODE_B_TYPE = 7'b1100011;
	localparam OPCODE_J_TYPE = 7'b1101111;
	//Define the intructions for ALU
	localparam ALU_ADD = 4'b0000;
	localparam ALU_SUB = 4'b0001;
	
    
	always_comb begin 
		case (opcode)
			OPCODE_R_TYPE: begin 
				//Type I (addi)
				if(funct_3 == 3'b000)begin 
					regwrite = 1'b1;
					aluscr = 1'b1; //don't use rs2
					alucontrol = ALU_ADD;
					immrd = I;
					memread = 0;
					memwrite = 0;
					branch = 0;
				//Type R (add)
				end else if (funct_3 == 3'b000 && funct_7 == 7'b0000000) begin 
					regwrite = 1'b1;
        	aluscr = 1'b0; //use rs2
        	alucontrol = ALU_ADD;
        	immrd = '0;
        	memread = 0;
        	memwrite = 0;
        	branch = 0;
				//Type R (sub)
				end else if (funct_3 == 3'b000 && funct_7 == 7'b0100000) begin
					regwrite = 1'b1;
					aluscr = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					immrd = '0;
					memread = 0;
					memwrite = 0;
					branch = 0;
 				end
			end
			OPCODE_B_TYPE: begin 
				//Type B(bne)
				if(funct_3 == 3'b001 ) begin
					regwrite = 1'b0;
					alusrc = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					immrd = B;
					memread = 1'b0;
					memwrite = 1'b0;
					branch = 1'b1;
				end
			end
			OPCODE_J_TYPE: begin 
				regwrite =1'b1;
				alusrc = 1'b0;
				alucontrol = ALU_ADD;
				immrd = J;
				memread = 1'b0;
				memwrite = 1'b0;
				branch = 1'b1;
			end 
			//default NOP
			default: begin
				regwrite = 1'b0;
				memread = 1'b0;
				memwrite = 1'b0;
				alusrc = 1'b0;
				branch = 1'b0;
				alucontrol = ALU_ADD;
				immrd = '0;  
			end	
		endcase 
	end
endmodule
