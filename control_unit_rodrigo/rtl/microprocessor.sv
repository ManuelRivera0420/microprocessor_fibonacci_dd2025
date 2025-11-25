module microprocessor (
    input logic clk, 
    input logic arst_n,
    input logic [DATA_WIDTH - 1:0] instruction
    	
);

`include "defines.svh"

//internal signals
//signals for prf////////////
logic uc_reg_write_en;
logic [4:0] uc_rd_dir;
logic [4:0] uc_r1_dir;
logic [4:0] uc_r2_dir;
logic [DATA_WIDTH - 1: 0] data_prf_in;
////signals for alu/////
logic [DATA_WIDTH - 1: 0] r1_to_mux;
logic [DATA_WIDTH - 1: 0] r2_to_mux;
logic sel_r1;
logic sel_r2;
logic [DATA_WIDTH - 1: 0] alu_operand1;
logic [DATA_WIDTH - 1: 0] mux_to_alu_operand2;
logic [3:0] alucontrol;
////////////////////////////
//signals for program counter/////
logic pc_write;
logic zero;
logic [1:0] pc_sel; 
logic [DATA_WIDTH - 1:0] pc_imm_in;
logic [DATA_WIDTH - 1:0] pc_out;

//signals for imm_gen 
logic [2:0] imm_sel;
logic [DATA_WIDTH - 1:0] imm_out_to_mux;
//signals for control unit ////
logic [4:0] instruction_rd_dir;
logic [4:0] instruction_r1_dir;
logic [4:0] instruction_r2_dir;

//instanciation of intruction memory/// 
instruction_memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .BYTE_WIDTH(BYTE_WIDTH), .MEM_DEPTH(MEM_DEPTH)) instruction_memory_i (
    .clk(clk)
        
);

///////////////////////////////////////
//instanciation of prf
bank_reg_s #(.DIR_WIDTH(DIR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) prf_i (
    .clk(clk),
    .arst_n(arst_n),
    .write_en(uc_reg_write_en),
    .read_dir1(uc_r1_dir),
    .read_dir2(uc_r2_dir),
    .write_dir(uc_rd_dir),
    .write_data(data_prf_in),
    .read_data1(alu_operand1),
    .read_data2()
);

//instanciation of ALU
alu #(.N(DATA_WIDTH)) alu_i(
    .operand1(alu_operand1),
    .operand2(mux_to_alu_operand2),
    .alucontrol(alucontrol),
    .zero(zero),
    .alu_result()
);

//instanciatioon of PC
program_counter pc_i (
    .clk(clk),
    .arst_n(arst_n),
    .pc_write(pc_write),
    .zero(zero),
    .pc_sel(pc_sel),
    .pc_imm_in(pc_imm_in),
    .pc(pc_out)

);
//instanciation of immgen
imm_gen imm_gen_i (
    .instr(instruction),
    .imm_sel(imm_sel),
    .imm_out(imm_out_to_mux)
);

//instanciation of mux imm_gen 

mux #(.WIDTH(32)) mux_imm_gen_i(
    .in1(imm_out_to_mux),
    .in2(r2_to_mux),
    .sel(sel_r2),
    .out(mux_to_alu_operand2)
);


//instanciation of ocntrol unit 
control_unit control_unit_i (
    .opcode   (instruction[6:0]),
    .funct_7  (instruction[31:25]),
    .funct_3  (instruction[14:12]),
    //inputs and outputs for prf////////////////////
    .regwrite (uc_reg_write),
    .rd_in(instruction_rd_dir),
    .r1_in(instruction_r1_dir),
    .r2_in(instruction_r2_dir),
    .rd_out(uc_rd_dir),
    .r1_out(uc_r1_dir),
    .r2_out(uc_r2_dir),
    ///////////////////////////////////////////////
    .memread  (),
    .memwrite (),
    .memtoreg (),
    ///////////////////////////////////////////////
	//inputs and outputs for PC////////////
    .pc_write (),
    .pc_sel   (),
    .imm_type (),
    //inputs for ALU
    .alusrc_r1 (sel_r1),
    .alusrc_r2 (sel_r2),
    .alucontrol(alucontrol)
);

endmodule

