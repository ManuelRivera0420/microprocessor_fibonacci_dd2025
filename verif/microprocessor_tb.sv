module microprocessor_tb ();

 `include "defines.svh"
    
    bit clk;
    bit arst_n;
    
    // para el testbench
    logic [DIR_WIDTH-1:0] rd, rs1, rs2;
    logic [12:0] imm_bq;
    logic [20:0] imm_jal;
    
    logic [DATA_WIDTH-1:0] instruction_tb_addi, instruction_tb_add, instruction_tb_beq, instruction_tb_jal;
    logic [DIR_WIDTH-1:0] rd_tb, rs1_tb, rs2_tb;
    logic [11:0] imm_tb;   

    // para el BIND 
    logic [DATA_WIDTH-1:0] alu_result;
    logic [DATA_WIDTH-1:0] pc_out, pc_imm; // Señales para conectar al bind
    logic memread, memwrite, memtoreg;
    
    always #5ns clk = !clk;
	assign #10ns arst_n = 1'b1;

    microprocessor_if tbprocessor_if(clk, arst_n);
    microprocessor_top tbprocessor_top(clk, arst_n);    
    
    microprocessor_top microprocessor_i ( 
        .clk(clk),
        .arst_n(arst_n),
        .instruction(tbprocessor_if.instruction)
    );

     
    `define  MEM_PATH microprocessor_i.instruction_memory_i
	`define  ALU_PATH microprocessor_i.alu_i
	`define  BANK_REG_PATH microprocessor_i.prf_i
	`define  PC_PATH microprocessor_i.pc_i
	`define  IMM_GEN_PATH microprocessor_i.imm_gen_i
	`define  MUX_IMM_PATH microprocessor_i.mux_imm_gen_i
	`define  MUX_PC_PATH microprocessor_i.mux_pc_i
	`define  CU_PATH microprocessor_i.control_unit_i
    
    typedef enum bit [6:0] {
      addi = 7'b0010011,
      add  = 7'b0110011,
      beq  = 7'b1100011,
      jal  = 7'b1101111
    } operation;
    
    operation current_instruction;      
    
       
    
    initial begin
    wait (arst_n);
      $display("--- Decodificador de Instrucciones (RISC-V Opcode) ---");
      
      
      repeat (100) @(posedge clk) begin
      randcase
        1 :  begin // ADDI
                std::randomize(rd,rs1);
                tbprocessor_if.write_addi_instr(rd,rs1);
                current_instruction = tbprocessor_if.instruction[6:0];
                rd_tb = tbprocessor_if.instruction[11:7];
                rs1_tb = tbprocessor_if.instruction[19:15];
                imm_tb = tbprocessor_if.instruction[DATA_WIDTH-1:DATA_WIDTH-12];
                instruction_tb_addi = tbprocessor_if.instruction;
                if (`ALU_PATH.alu_result == (`ALU_PATH.operand1 + `ALU_PATH.operand2)); 
                else $error("ERROR!! Resultado esperado de %d + %d  = %d", `ALU_PATH.operand1, `ALU_PATH.operand2, `ALU_PATH.alu_result );
                if (`BANK_REG_PATH.write_dir == rd); 
                else $error("ERROR!! Dirección esperada = %d, diorección escrita = %d", `BANK_REG_PATH.write_dir, rd);            
                end

        1 : begin // ADD
                std::randomize(rs1,rs2,rd);
                tbprocessor_if.write_add_instr(rs1,rs2,rd);
                current_instruction = tbprocessor_if.instruction[6:0];
                rd_tb = tbprocessor_if.instruction[11:7];
                rs1_tb = tbprocessor_if.instruction[19:15];
                rs2_tb = tbprocessor_if.instruction[24:20];
                instruction_tb_add = tbprocessor_if.instruction;
                if (`ALU_PATH.alu_result == (`ALU_PATH.operand1 + `ALU_PATH.operand2)); 
                else $error("ERROR!! Resultado esperado de %d + %d  = %d", `ALU_PATH.operand1, `ALU_PATH.operand2, `ALU_PATH.alu_result );
                 
                 if (`BANK_REG_PATH.write_dir == rd_tb);
                 else $error("ERROR!! Dirección esperada = %d,  dirección escrita = %d", rd_tb, `BANK_REG_PATH.write_dir);
                 end


        1 : begin //BEQ
                std::randomize(rs1,rs2,imm_bq);
                tbprocessor_if.write_beq_instr(rs1,rs2,imm_bq);
                current_instruction = tbprocessor_if.instruction[6:0];
                rs1_tb = tbprocessor_if.instruction[19:15];
                rs2_tb = tbprocessor_if.instruction[24:20];
                instruction_tb_beq = tbprocessor_if.instruction;
		    end
        
        1 : begin //JAL
                std::randomize(rd,imm_jal);
                tbprocessor_if.write_jal_instr (rd,imm_jal);
                current_instruction = tbprocessor_if.instruction[6:0];
                rd_tb = tbprocessor_if.instruction[11:7];
                instruction_tb_jal = tbprocessor_if.instruction;
		    end
      endcase
    end
end

        
    initial begin // Initial block to open shared memory and probe signals
			$shm_open("shm_db");
			$shm_probe("ASMTR");
	end
    
	initial begin // Timeout thread
		#10us;
		$finish;
	end
    
endmodule