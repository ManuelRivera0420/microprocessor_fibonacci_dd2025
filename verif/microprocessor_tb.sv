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
    
    //CHECKS
    logic [31:0] pc_before;
    logic [31:0] imm_check;
    logic [31:0] rd_expected;
    logic [31:0] beq_taken;
    logic [31:0] beq_notaken;
    logic equal;
    logic [6:0] count_add, count_addi, count_beq, count_jal, count_add_g, count_addi_g, count_beq_g, count_jal_g;
    
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
    count_add = 0; count_addi= 0; count_beq = 0; count_jal = 0;
    count_add_g = 0; count_addi_g = 0; count_beq_g = 0; count_jal_g = 0;
    
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
                count_addi = count_addi + 1;
                @(posedge clk); // Esperamos un ciclo
                    if (`ALU_PATH.alu_result !== (`ALU_PATH.operand1 + `ALU_PATH.operand2)) begin
                      $error("ERROR EN ADDI!! ALU: esperado %0d + %0d = %0d, obtenido = %0d",
                             `ALU_PATH.operand1, `ALU_PATH.operand2,
                             `ALU_PATH.operand1 + `ALU_PATH.operand2, `ALU_PATH.alu_result);
                    end
                    if (`BANK_REG_PATH.write_dir !== rd) begin
                      $error("ERROR EN ADDI!! Dirección esperada = %0d, dirección escrita = %0d",
                             rd, `BANK_REG_PATH.write_dir);
                    end else begin 
                    count_addi_g = count_addi_g + 1;
                    end
              end

        1 : begin // ADD
                std::randomize(rs1,rs2,rd);
                tbprocessor_if.write_add_instr(rs1,rs2,rd);
                current_instruction = tbprocessor_if.instruction[6:0];
                rd_tb = tbprocessor_if.instruction[11:7];
                rs1_tb = tbprocessor_if.instruction[19:15];
                rs2_tb = tbprocessor_if.instruction[24:20];
                instruction_tb_add = tbprocessor_if.instruction;
                count_add =count_add +1;
                @(posedge clk); 
                if (`ALU_PATH.alu_result !== (`ALU_PATH.operand1 + `ALU_PATH.operand2)) begin
                  $error("ERROR EN ADD!! ALU: esperado %0d + %0d = %0d, obtenido %0d",
                         `ALU_PATH.operand1, `ALU_PATH.operand2,
                         `ALU_PATH.operand1 + `ALU_PATH.operand2, `ALU_PATH.alu_result);
                end        
                if (`BANK_REG_PATH.write_dir !== rd) begin
                  $error("ERROR EN ADD!! Dirección esperada = %0d, dirección escrita = %0d",
                         rd, `BANK_REG_PATH.write_dir);
                end else begin 
                count_add_g = count_add_g + 1;
                end
              end


        1 : begin //BEQ
                std::randomize(rs1,rs2,imm_bq);
                tbprocessor_if.write_beq_instr(rs1,rs2,imm_bq);
                current_instruction = tbprocessor_if.instruction[6:0];
                rs1_tb = tbprocessor_if.instruction[19:15];
                rs2_tb = tbprocessor_if.instruction[24:20];
                instruction_tb_beq = tbprocessor_if.instruction;
                pc_before = $signed(`PC_PATH.pc);
                equal = (rs1 == rs2);
                imm_check = $signed({imm_bq[12], imm_bq[10:5], imm_bq[4:1], imm_bq[11], 1'b0});
                beq_taken = pc_before + imm_check;
                beq_notaken = pc_before + 4;
                rd_expected = equal ? beq_taken : beq_notaken;
                count_beq = count_beq + 1;
                @(posedge clk);
                if ($signed(`PC_PATH.pc) !== rd_expected) begin
                  $error("ERROR BEQ FALLÓ!\n  PC actual     = %d \n   PC anterior    = %d \n %d, %d -> condición: %0s\n   Inmediato B    = %0d (%b)\n  Esperado       = %d  (%0s)",
                         $signed(`PC_PATH.pc), pc_before,
                         rs1, rs2, equal ? "IGUALES -> TOMADO" : "DIFERENTES -> NO TOMADO",
                         imm_check, imm_bq,
                         rd_expected,
                         equal ? "SALTO TOMADO" : "SALTO NO TOMADO");
                end else begin
                    count_beq_g = count_beq_g + 1;
                end 
		    end
        
        1 : begin //JAL
                std::randomize(rd,imm_jal);
                tbprocessor_if.write_jal_instr (rd,imm_jal);
                current_instruction = tbprocessor_if.instruction[6:0];
                rd_tb = tbprocessor_if.instruction[11:7];
                instruction_tb_jal = tbprocessor_if.instruction;
                pc_before = $signed(`PC_PATH.pc);
                imm_check = $signed({{12{imm_jal[20]}}, imm_jal[20:0], 1'b0});
                rd_expected = pc_before + imm_check;
                count_jal = count_jal + 1;
                @(posedge clk);
                if ($signed(`PC_PATH.pc) !== rd_expected) begin
                  $error("ERROR JAL: Salto incorrecto!\n   PC actual = %d\n   Esperado    = PC(%d) + imm(%0d) = %d",
                         $signed(`PC_PATH.pc), pc_before, imm_check, rd_expected);
                if (`BANK_REG_PATH.write_dir !== rd) begin
                  $error("ERROR JAL: write_dir = %0d, esperado rd=%0d", `BANK_REG_PATH.write_dir, rd);
                end
                if (`BANK_REG_PATH.write_data !== pc_before + 4) begin
                  $error("ERROR JAL: No guardó PC+4 en rd!\n   Escrito = %d\n   Esperado = PC+4 = %d",
                         `BANK_REG_PATH.write_data, pc_before + 4);
                end else begin
                    count_jal_g = count_jal_g + 1;
		          end
		    end
      endcase  
    end  
    $display("TOTAL DE OPERACIONES = %d \n ADD  = %d    Sin errores = %d \n ADDI = %d    Sin errores = %d \n BEQ  = %d    Sin errores = %d \n JAL  = %d    Sin errores = %d ",count_add+count_addi+count_beq+count_jal,count_add,count_add_g, count_addi,count_addi_g, count_beq,count_beq_g, count_jal, count_jal_g);   
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
