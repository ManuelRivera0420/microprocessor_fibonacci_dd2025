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
	input logic [6:0] funct_7, //instructions [31:25]
	output logic regwrite,
	output logic memread,
	output logic memwrite,
	output logic memtoreg,
	output logic alusrc,
	output logic pc_write,
	output logic [1:0] pc_sel,
	output logic [2:0] imm_type,
	output logic [3:0] alucontrol
);
	//Define the instructions 
	`include "../../defines.svh"
    
	always_comb begin 
		unique case (opcode)
			OPCODE_I_TYPE: begin 
				//Type I (addi)
				if(funct_3 == 3'b000)begin 
					regwrite = 1'b1;
					alusrc = 1'b1; //don't use rs2
					alucontrol = ALU_ADD;
					imm_type = IMM_I;
					memread = '0;
					memwrite = '0;
					pc_write = 1'b1;
					pc_sel = PC_4; // pc + 4
				end	
			end	
			OPCODE_B_TYPE: begin 
				//Type B(bne)
				if(funct_3 == 3'b001 ) begin
					regwrite = 1'b0;
					alusrc = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_B;
					pc_sel = PC_IMM; //Use imm to count  PC +  imm
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0;
				end
			end
			 OPCODE_R_TYPE: begin 
			     if (funct_3 == 3'b000 && funct_7 == 7'b0000000) begin 
			        regwrite = 1'b1;
					alusrc = 1'b0; //use rs2
					alucontrol = ALU_ADD;
					imm_type = IMM_NF;
					pc_sel = PC_4; //Use   PC +  4
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0; 
			     end else if (funct_3 == 3'b000 && funct_7 == 7'b0100000) begin 
  			        regwrite = 1'b1;
					alusrc = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_NF;
					pc_sel= PC_4; //Use   PC +  4
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0;        
			     end
			 end
			//default NOP
			default: begin
				regwrite = 1'b0;
				memread = 1'b0;
				memwrite = 1'b0;
				alusrc = 1'b0;
				alucontrol = ALU_ADD;
				imm_type = IMM_NF;
				pc_sel= '1;  
				pc_write = 1'b0;
			end	
		endcase
	end
endmodule

