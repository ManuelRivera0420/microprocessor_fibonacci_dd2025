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
	output logic [1:0] pc_sel,
	output logic [2:0] imm_type,
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
	//define the imm instructions 
    localparam IMM_I = 3'b000;   // Type I  (ADDI, LW, JALR, etc.)
    localparam IMM_S = 3'b001;   // Type S  (SW, SH, SB)
    localparam IMM_B = 3'b010;   // Type B  (BEQ, BNE, etc.)
    localparam IMM_U = 3'b011;   // Type U  (LUI, AUIPC)
    localparam IMM_J = 3'b100;   // Type J  (JAL)
    localparam IMM_NF = 3'b101; //No function 
    //define the PC count logic instructions 
    localparam PC_4 = 2'b00;
    localparam PC_IMM = 2'b01; 
    
    
    
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
					memread = 1'b0;
					memwrite = 1'b0; 
			     end else if (funct_3 == 3'b000 && funct_7 == 7'b0100000) begin 
  			        regwrite = 1'b1;
					alusrc = 1'b0; //use rs2
					alucontrol = ALU_SUB;
					imm_type = IMM_NF;
					pc_sel= PC_4; //Use   PC +  4
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
			end	
		endcase
	end
endmodule

