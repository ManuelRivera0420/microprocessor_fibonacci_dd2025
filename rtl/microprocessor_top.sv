module microprocessor_top (
    input logic clk, 
    input logic arst_n,
    input logic prog_ready,
    input logic w_en,
    output logic prog_ack
);

`include "defines.svh"

logic [DATA_WIDTH - 1:0] pc_mux_out; //enable of PC_4 or PC_BRANCH
logic [DATA_WIDTH - 1:0] wr_addr; // Current instruction to read in instruction memory
logic cu_pc_add_sel; // Selector to add +4 or +2 
logic [2:0] instruction_increment; // operand to add +4 o +2 
logic [DATA_WIDTH - 1:0] instruction_out; //instruction from instruction memory
logic prf_wr_en; //prf write enable 
logic [DATA_WIDTH - 1:0] rs_1; //reg_1
logic [DATA_WIDTH - 1:0] rs_2; //reg_2
logic [DATA_WIDTH - 1:0] mem_mux_out;
logic pc_mux_ctrl; // use rs1 or pc_out
logic imm_mux_ctrl; //use rs2 or imm_out 
logic [DATA_WIDTH - 1:0] mux_to_operand_1; // operand 1 for ALU
logic [DATA_WIDTH - 1:0] mux_to_operand_2; // operand 2 for ALU
logic [DATA_WIDTH - 1:0] imm_to_operand_2; // imm out to mux for 
logic [3:0] cu_alu_ctrl; //selector for ALU operations
logic [DATA_WIDTH - 1:0] alu_to_mem_addr; // Resutl of ALU
logic [DATA_WIDTH - 1:0] next_instruction_addr;  //  add pc + 4 or pc + immediate
logic cu_data_mem_wr_en; // enable data memory write
logic [2:0] cu_imm_sel; //selector of IMM_TYPE
logic [1:0] cu_mem_out_mux_sel; // selector for mux to MEM,ALU,PC directions
logic branch_taken; //selector for add pc + 4 or pc + immediate
logic [31:0] data_in;
logic zero;
//INPUT MUX FOR PC
mux #(.WIDTH(DATA_WIDTH)) pc_mux_i(
    .in1(alu_to_mem_addr),
    .in2(next_instruction_addr),
    .sel(branch_taken),
    .out(pc_mux_out)   
);
//PROGRAM COUNTER
program_counter pc_i (
    .clk(clk),
    .arst_n(arst_n),
    .prog_ready(prog_ready),
    .pc_in(pc_mux_out),
    .prog_ack(prog_ack),
    .pc_out(wr_addr)

);
//MUX OPERANDS FOR PROGRAM COUNTER ADD
plus_4_or_2_mux pc_adder_i (
    .sel(cu_pc_add_sel),
    .instruction_add(instruction_increment)
);
//ADDER FOR PROGRAM COUNTER
adder #(.DATA_WIDTH(DATA_WIDTH)) instruction_adder_i (
    .constant_operand(instruction_increment),
    .instruction_addr(wr_addr),
    .next_instruction (next_instruction_addr)
);
//INSTRUCTION MEMORY
instruction_memory #(.BYTE_WIDTH(BYTE_WIDTH), .MEM_DEPTH(MEM_DEPTH), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) instruction_memory_i (
    .clk(clk),
    .data_in(data_in),
    .rd_addr(wr_addr),
    .wr_addr('0),
    .w_en(w_en),
    .rd_data(instruction_out)
);
//PHYSICAL REGISTER FILE 
physical_register_file #(.DIR_WIDTH(DIR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) prf_i (
    .clk(clk),
    .arst_n(arst_n),
    .write_en(prf_wr_en),
    .read_dir1(instruction_out[19:15]),
    .read_dir2(instruction_out[24:20]),
    .write_dir(instruction_out[11:7]),
    .write_data(mem_mux_out),
    .read_data1(rs_1),
    .read_data2(rs_2)
);
//MUX FOR OPERAND 1 IN ALU
mux #(.WIDTH(DATA_WIDTH)) pc_reg1_mux_i(
    .in1(wr_addr),
    .in2(rs_1),
    .sel(pc_mux_ctrl),
    .out(mux_to_operand_1)   
);
//MUX FOR OPERAND 2 IN ALU
mux #(.WIDTH(DATA_WIDTH)) imm_reg2_mux_i(
    .in1(imm_to_operand_2),
    .in2(rs_2),
    .sel(imm_mux_ctrl),
    .out(mux_to_operand_2)   
);
//ARITHMETIC LOGIC UNIT
alu #(.N(DATA_WIDTH)) alu_i(
    .operand1(mux_to_operand_1),
    .operand2(mux_to_operand_2),
    .alucontrol(cu_alu_ctrl),
    .alu_result(alu_to_mem_addr)
);
//DATA MEMORY
data_memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_DEPTH(MEM_DEPTH)) data_memory_i(
    .clk(clk),
    .w_en(cu_data_mem_wr_en),
    .wr_addr(alu_to_mem_addr),
    .data_in(rs_2),
    .rd_data(data_out)
);

//instanciation of immgen
imm_gen imm_gen_i (
    .instr(instruction_out),
    .imm_sel(cu_imm_sel),
    .imm_out(imm_to_operand_2)
);

//CONTROL UNIT 
control_unit control_unit_i (
    .opcode   (instruction_out[6:0]),
    .funct_7  (instruction_out[31:25]),
    .funct_3  (instruction_out[14:12]),
    .prf_wr_en(prf_wr_en),
    .cu_imm_sel(cu_imm_sel),
    .prf_pc_mux_ctrl(pc_mux_ctrl),
    .prf_imm_mux_ctrl(imm_mux_ctrl),
    .cu_alu_ctrl(cu_alu_ctrl),
    .cu_mem_out_mux_sel(cu_mem_out_mux_sel),
    .cu_data_mem_wr_en(cu_data_mem_wr_en),
    .cu_pc_add_sel(cu_pc_add_sel),
    .zero(zero),
    .branch_taken(branch_taken)
);

//BRANCH
branch #(.DATA_WIDTH(DATA_WIDTH)) branch_i (
    .rs_1(rs_1),
    .rs_2(rs_2),
    .branch_taken(zero)
);
//MUX MEM,ALU,PC directions
mux_3_to_1  data_mem_mux_i (
    .data_out_to_pc(next_instruction_addr),
    .alu_to_mem_addr(alu_to_mem_addr),
    .data_out_to_mux(data_out),
    .sel(cu_mem_out_mux_sel),
    .data_out(mem_mux_out)
);


endmodule



