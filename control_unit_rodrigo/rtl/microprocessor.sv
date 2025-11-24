module microprocessor (
    input logic clk, 
    input logic arst_n,
    input logic [31:0] intruction
    	
);

//instanciation of prf
bank_reg prf_i (
    .clk(clk),
    .arst_n(arst_n),
    .write_en(),
    .read_dir1(),
    .read_dir2(),
    .write_dir(),
    .write_data(),
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
alu alu_i(
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
    .regwrite (),
    .memread  (),
    .memwrite (),
    .memtoreg (),
    .alusrc_r1 (),
    .alusrc_r3 (),
    .pc_write (),
    .pc_sel   (),
    .imm_type (),
    .alucontrol()
);

endmodule
