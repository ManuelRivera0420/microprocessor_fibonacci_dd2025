`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 14.11.2025 18:24:51
// Design Name: 
// Module Name: control_unit
//////////////////////////////////////////////////////////////////////////////////

module control_unit(
	input logic [6:0]  opcode,             //instrucctions [6:0]
	input logic [2:0]  funct_3,            //instructions [14:12]
	input logic [6:0]  funct_7,            //instructions [31:25]
	input logic zero,	
	output logic       prf_wr_en,          //writte enable of prf 
	output logic [2:0] cu_imm_sel,         //control unit to immediate selector
	output logic       prf_pc_mux_ctrl,    //selector to pc_mux 
	output logic       prf_imm_mux_ctrl,   //selector to imm_mux 
	output logic [3:0] cu_alu_ctrl,        //selector for ALU 
	output logic [1:0] cu_mem_out_mux_sel, //selector for MEM,ALU,PC directions
	output logic       cu_data_mem_wr_en,  //write enable for data mem
	output logic       cu_pc_add_sel,       //selector to add +4 or +2 to 
	output logic branch_taken,
	output logic w_en
);
//Define the instructions 
`include "defines.svh"
	always_comb begin 
		unique case (opcode)
			OPCODE_I_TYPE: begin
                 prf_wr_en =             1'b1;          //enable prf write
                 cu_data_mem_wr_en =     1'b0;          //disable data_mem write
                 cu_imm_sel =            IMM_I;         //use IMM_I_TYPE 
                 prf_pc_mux_ctrl =       1'b0;          //use rs1 as opreand 1 in ALU
                 prf_imm_mux_ctrl =      1'b1;          //don't use rs2 instead use imm_gen
                 cu_pc_add_sel =         1'b0;          //Add +4 to pc_in
                 cu_mem_out_mux_sel =    ALU_TO_PRF;    //send the result of ALU to prf data_in       
                 branch_taken = 1'b0;
			     case (funct_3) 
			         //(addi)
                    ADDI: begin 
                        cu_alu_ctrl =           ALU_ADD;       //ADD operation in ALU
                    end 
                    //(slti)
                    SLTI: begin 
                        cu_alu_ctrl =           ALU_SLT;       //SLT operation in ALU       
                    end
                    //(sltiu)
                    SLTIU: begin 
                        cu_alu_ctrl =           ALU_SLTU;       //SLTU operation in ALU   
                    end
                    //(xori)
                    XORI: begin 
                        cu_alu_ctrl =           ALU_XOR;       //XOR operation in ALU
                    end
                    //(slti)
                    ORI: begin 
                        cu_alu_ctrl =           ALU_OR;       //OR operation in ALU      
                    end
                    //(ANDI)
                    ANDI: begin 
                        cu_alu_ctrl =           ALU_AND;       //AND operation in ALU
                    end
			     endcase
			end	
			OPCODE_B_TYPE: begin
                prf_wr_en =             1'b0;          //disable prf write
                cu_data_mem_wr_en =     1'b0;          //disable data_mem write
                cu_imm_sel =            IMM_B;         //use IMM_B_TYPE 
                prf_pc_mux_ctrl =       1'b1;          //use rs1 as opreand 1 in ALU
                prf_imm_mux_ctrl =      1'b1;          //use rs2 as operand 2 in ALU 
                cu_mem_out_mux_sel =    ALU_TO_PRF;    //send the result of ALU to prf data_in       
				    //Type B(BEQ)
                    case (funct_3)
                    BEQ: begin
                        if (zero == 1'b1) begin
                        cu_alu_ctrl =           ALU_ADD;       //ADD operation in ALU
                        cu_pc_add_sel =         1'b0;          //Add +4 to pc_in
                        branch_taken = 1'b1;
                        end else 
                        branch_taken = 1'b0;
                     end                       
                    endcase
			end
			
			OPCODE_R_TYPE: begin
                 prf_wr_en =             1'b1;          //enable prf write
                 cu_data_mem_wr_en =     1'b0;          //disable data_mem write
                 cu_imm_sel =            IMM_NF;         //use IMM_NO_FUNCTION_TYPE 
                 prf_pc_mux_ctrl =       1'b0;          //use rs1 as opreand 1 in ALU
                 prf_imm_mux_ctrl =      1'b0;          //use rs2 as operand 2 in ALU
                 cu_pc_add_sel =         1'b0;          //Add +4 to pc_in
                 cu_mem_out_mux_sel =    ALU_TO_PRF;    //send the result of ALU to prf data_in  
                 branch_taken = 1'b0;     
			     if (funct_7 == 7'b0000000) begin 
			         case (funct_3)
			             //ADDITION OPERATION
			             ADD: begin 
					         cu_alu_ctrl =           ALU_ADD;       //ADD operation in ALU
			             end
			             //LOGICAL LEFT SHIFT
			             SLL: begin 
					         cu_alu_ctrl =           ALU_SLL;       //SLL operation in ALU
			             end
			             //SIGNED COMPARISON
			             SLT: begin 
					         cu_alu_ctrl =           ALU_SLT;       //SLT operation in ALU
			             end
			             //UNSIGNED COMPARISON
			             SLTU: begin 
					         cu_alu_ctrl =           ALU_SLTU;       //SLTU operation in ALU
			             end
			             //XOR
			             XOR_: begin 
					         cu_alu_ctrl =           ALU_XOR;       //XOR operation in ALU
			             end
			             //RIGHT LOGICAL SHIFT 
			             SRL: begin 
					         cu_alu_ctrl =           ALU_SRL;       //SRL operation in ALU
			             end
			             //OR
			             OR_: begin 
					         cu_alu_ctrl =           ALU_OR;       //OR operation in ALU
			             end
			             //AND
			             AND_: begin 
					         cu_alu_ctrl =           ALU_AND;       //AND operation in ALU
			             end
			         endcase
			     end else if (funct_7 == 7'b0100000) begin
                     prf_wr_en =             1'b1;          //enable prf write
                     cu_data_mem_wr_en =     1'b0;          //disable data_mem write
                     cu_imm_sel =            IMM_NF;         //use IMM_NO_FUNCTION_TYPE 
                     prf_pc_mux_ctrl =       1'b0;          //use rs1 as opreand 1 in ALU
                     prf_imm_mux_ctrl =      1'b0;          //use rs2 as operand 2 in ALU
                     cu_mem_out_mux_sel =    ALU_TO_PRF;    //send the result of ALU to prf data_in       
                     cu_pc_add_sel =         1'b0;          //Add +4 to pc_in 
                     branch_taken = 1'b0;
			         case(funct_3) 
			             //SUBTRACTION OPERATION
			             SUB: begin
					         cu_alu_ctrl =           ALU_SUB;       //SUB operation in ALU
					         
			             end
			             //SIGN-EXTEND SHIFT OPERATION
			             SRA: begin 
					         cu_alu_ctrl =           ALU_SRA;       //SUB operation in ALU
			             end
			         endcase 
			     end
			end
			OPCODE_J_TYPE: begin 
			     prf_wr_en =             1'b1;          //disable prf write
                 cu_data_mem_wr_en =     1'b0;          //disable data_mem write
                 cu_imm_sel =            IMM_J;         //use IMM_NO_FUNCTION_TYPE 
                 prf_pc_mux_ctrl =       1'b1;          //use pc_out as opreand 1 in ALU
                 prf_imm_mux_ctrl =      1'b1;          //use imm as operand 2 in ALU
                 cu_mem_out_mux_sel =    INSTRUCTION_TO_PRF;    //send the result of ALU to prf data_in       
                 cu_pc_add_sel =         1'b0;          //Add imm to pc_in 
                 cu_alu_ctrl =           ALU_ADD;       //SUB operation in ALU
                 branch_taken = 1'b1;
			end	
		endcase
	end
assign w_en = 1'b1;
endmodule


