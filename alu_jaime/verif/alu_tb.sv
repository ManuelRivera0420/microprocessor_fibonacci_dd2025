`timescale 1ns / 1ps
`include "defines.svh"


// ALU testbench
module alu_tb #(parameter N = 32)();
    bit clk;
    logic [N-1:0] reg_source1;
    logic [N-1:0] reg_source2;
    logic [3:0]   alucontrol;
    logic zero;
    logic [N-1:0] reg_destiny;
    logic [N-1:0] expected;
    
    // ALU instantiation
    alu #(.N(N)) DUT (
        .reg_source1(reg_source1),
        .reg_source2(reg_source2),
        .alucontrol(alucontrol),
        .reg_destiny(reg_destiny)
    );
    
    // Clock used for assertation
    initial clk = 0;
    always #5ns clk = ~clk;
    
    // Model ALU for assertations
    // Onlt Shift right arithmetic fails, but we might remove it anyway
    task compute_alu();
        unique case(alucontrol)
            ALU_ADD:  expected = reg_source1 + reg_source2;
            ALU_SUB:  expected = reg_source1 - reg_source2;
            ALU_AND:  expected = reg_source1 & reg_source2;
            ALU_OR:   expected = reg_source1 | reg_source2;
            ALU_XOR:  expected = reg_source1 ^ reg_source2;
            ALU_EQ:   expected = reg_source1 == reg_source2;
            ALU_SLT:  expected = $signed(reg_source1) < $signed(reg_source2);
            ALU_SLTU: expected = reg_source1 < reg_source2;
            ALU_SLL:  expected = reg_source1 << reg_source2;
            ALU_SRL:  expected = reg_source1 >> reg_source2;
            ALU_SRA:  expected = $signed(reg_source1) >>> reg_source2;
            default: expected = '0;
        endcase
    endtask
    
    assert property (@(posedge clk)expected == reg_destiny);
    
    initial begin
        repeat(50) begin
            // Randomize inputs and wait a clock cycle before proceeding
            std::randomize(reg_source1, reg_source2, alucontrol);
            compute_alu();
            @(posedge clk);
        end
        $finish;
    end
endmodule
