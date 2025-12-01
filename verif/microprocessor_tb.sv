module microprocessor_if_tb();
//    `include "defines.svh"
    
    bit clk;
    bit arst_n;
    logic [DIR_WIDTH-1:0] rd;
    logic [DIR_WIDTH-1:0] rs1;
    logic [DIR_WIDTH-1:0] rs2;
    logic [12:0] imm_bq;
    logic [20:0] imm_jal;
    logic [DATA_WIDTH - 1:0] instruction;
    
    always #5ns clk = !clk;
	assign #10ns arst_n = 1'b1;

    microprocessor_if tbprocessor_if(clk, arst_n);   
    
    `define  MEM_PATH microprocessor_i.instruction_memory_i
	`define  ALU_PATH microprocessor_i.alu_i
	`define  BANK_REG_PATH microprocessor_i.prf_i
	`define  PC_PATH microprocessor_i.pc_i
	`define  IMM_GEN_PATH microprocessor_i.imm_gen_i
	`define  MUX_IMM_PATH microprocessor_i.mux_imm_gen_i
	`define  MUX_PC_PATH microprocessor_i.mux_pc_i
	`define  CU_PATH microprocessor_i.control_unit_i
    
   typedef enum instruction [6:0] {
      addi = 7'b0010011,
      add  = 7'b0110011,
      beq  = 7'b1100011,
      jal  = 7'b1101111
    } operation;
 
    initial begin
    wait (arst_n);
     
        repeat(10)begin 
            std::randomize(rd,rs1);
            tbprocessor_if.write_addi_instr(rd,rs1);
            #10ns;
//            $display("RESULT = %d", `ALU_PATH.alu_result);
//		    $display("opcode = %d", `CU_PATH.opcode);
        end
                
        repeat(10)begin 
            std::randomize(rs1,rs2,rd);
            tbprocessor_if.write_add_instr(rs1,rs2,rd);
            #10ns;
//            $display("RESULT = %d", `ALU_PATH.alu_result);
//		    $display("opcode = %d", `CU_PATH.opcode);
        end
        
        repeat(10)begin 
            std::randomize(rs1,rs2,imm_bq);
            tbprocessor_if.write_beq_instr(rs1,rs2,imm_bq);
            #10ns;
//            $display("RESULT = %d", `ALU_PATH.alu_result);
//		    $display("opcode = %d", `CU_PATH.opcode);
        end
        
        repeat(10)begin 
            std::randomize(rd,imm_jal);
            tbprocessor_if.write_jal_instr (rd,imm_jal);
            #10ns;
//            $display("RESULT = %d", `ALU_PATH.alu_result);
//		    $display("opcode = %d", `CU_PATH.opcode);
        end
        
    end 

    microprocessor_top microprocessor_i (
        .clk(clk),
        .arst_n(arst_n),
        .instruction(tbprocessor_if.instruction)
        );
        
    initial begin // Initial block to open shared memory and probe signals
			$shm_open("shm_db");
			$shm_probe("ASMTR");
	end

	initial begin // Timeout thread
		#100us;
		$finish;
	end
    
endmodule
