module microprocessor (
    input logic clk, 
    input logic arst_n,
    input logic [31:0] instruction
    	
);

`include "defines.svh"

//internal signals
//signals for prf////////////
logic uc_reg_write_en;
logic [4:0] uc_rd_dir;
logic [4:0] uc_r1_dir;
logic [4:0] uc_r2_dir;
logic [DATA_WIDTH - 1: 0] data_prf_in;
////////////////////////////
//signals for control unit ////
logic [4:0] instruction_rd_dir;
logic [4:0] instruction_r1_dir;
logic [4:0] instruction_r2_dir;

//instanciation of prf
bank_reg_s #(.DIR_WIDTH(DIR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) prf_i (
    .clk(clk),
    .arst_n(arst_n),
    .write_en(uc_reg_write_en),
    .read_dir1(uc_r1_dir),
    .read_dir2(uc_r2_dir),
    .write_dir(uc_rd_dir),
    .write_data(data_prf_in),
    .read_data1(),
    .read_data2()
);

//instanciation of immgen
imm_gen imm_gen_i (
    .instr(instruction),
    .imm_sel(),
    .imm_out()
);

//instanciation of ALU
alu #(.N(DATA_WIDTH)) alu_i(
    .reg_source1(),
    .reg_source2(),
    .alucontrol(),
    .zero(zero),
    .reg_destiny()
);

//instanciation of ocntrol unit 
control_unit control_unit_i (
    .opcode   (),
    .funct_7  (),
    .funct_3  (),
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
    .alusrc_r1 (),
    .alusrc_r2 (),
    .pc_write (),
    .pc_sel   (),
    .imm_type (),
    .alucontrol()
);

endmodule
