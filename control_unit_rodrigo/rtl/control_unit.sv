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
	//inputs and outputs for prf////////////////////
	output logic regwrite,
	input logic [4:0] rd_in,
	input logic [4:0] r1_in,
	input logic [4:0] r2_in,
	output logic [4:0] rd_out,
	output logic [4:0] r1_out,
	output logic [4:0] r2_out,
	///////////////////////////////////////////////
	//inputs and outyups for out memory////////////
	output logic memread,
	output logic memwrite,
	output logic memtoreg,
    ///////////////////////////////////////////////
	//inputs and outyups for ALU////////////
	output logic alusrc_r1,
	output logic alusrc_r2,
	output logic [3:0] alucontrol,
    ///////////////////////////////////////////////
	//inputs and outputs for PC////////////
	output logic pc_write,
	output logic [1:0] pc_sel,
	output logic [2:0] imm_type
	
);
	//Define the instructions 
`include "defines.svh"
    
	always_comb begin 
		unique case (opcode)
			OPCODE_I_TYPE: begin 
				//Type I (addi)
				if(funct_3 == 3'b000)begin 
					regwrite = 1'b1;
					alusrc_r1 = 1'b0; // use rs1
					alusrc_r2 = 1'b1; //don't use rs2
					alucontrol = ALU_ADD;
					imm_type = IMM_I;
					memread = 1'b0;
					memwrite = 1'b0;
					memtoreg = 1'b0;
					pc_write = 1'b1;
					pc_sel = PC_4; // pc + 4
				end	
			end	
			OPCODE_B_TYPE: begin 
				//Type B(BEQ)
				if(funct_3 == 3'b000 ) begin
					regwrite = 1'b0;
					alusrc_r1 = 1'b0; // use rs1
					alusrc_r2 = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_B;
					pc_sel = PC_BRANCH; //Use imm to count  PC +  imm
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0;
					memtoreg = 1'b0;
				end
			end
			 OPCODE_R_TYPE: begin 
			     //ADD
			     if (funct_3 == 3'b000 && funct_7 == 7'b0000000) begin 
			        regwrite = 1'b1;
					alusrc_r1 = 1'b0; //use rs1
					alusrc_r2 = 1'b0; //use rs2
					alucontrol = ALU_ADD;
					imm_type = IMM_NF;
					pc_sel = PC_4; //Use   PC +  4
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0; 
					memtoreg = 1'b0;
				//SUB
			     end else if (funct_3 == 3'b000 && funct_7 == 7'b0100000) begin 
  			        regwrite = 1'b1;
					alusrc_r1 = 1'b0; //use rs1
					alusrc_r2 = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_NF;
					pc_sel= PC_4; //Use   PC +  4
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0;  
					memtoreg = 1'b0;      
			     end
			 end
			 OPCODE_J_TYPE: begin
			        regwrite = 1'b1;
					alusrc_r1 = 1'b0; //use rs1
					alusrc_r2 = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_NF;
					pc_sel= PC_BRANCH; //Use   PC +  imm
					pc_write = 1'b1;
					memread = 1'b0;
					memwrite = 1'b0;      
			 end
			//default NOP
			default: begin
				regwrite = 1'b0;
				memread = 1'b0;
				memwrite = 1'b0;
				alusrc_r1 = 1'b0; //use rs1
				alusrc_r2 = 1'b0; //use rs2
				alucontrol = ALU_ADD;
				imm_type = IMM_NF;
				pc_sel= '1;  
				pc_write = 1'b0;
				memtoreg = 1'b0;    
			end	
		endcase
	end
endmodule


