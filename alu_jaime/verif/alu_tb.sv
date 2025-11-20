`timescale 1ns / 1ps
import micro_const_pkg::*;

// ALU testbench
module alu_tb #(parameter N = 32)();
    bit clk;
    logic [N-1:0] reg_source1;
    logic [N-1:0] reg_source2;
    logic [N-1:0] immg_source;
    logic alusrc;
    logic [3:0]   instruction;
    logic [N-1:0] reg_destiny;
    
    logic [N-1:0] second_operand;
    logic [N-1:0] expected;
    
    // ALU instantiation
    alu #(.N(N)) DUT (
        .reg_source1(reg_source1),
        .reg_source2(reg_source2),
        .immg_source(immg_source),
        .alusrc(alusrc),
        .instruction(instruction),
        .reg_destiny(reg_destiny)
    );
    
    // Clock used for assertation
    initial clk = 0;
    always #5ns clk = ~clk;
    
    assign second_operand = alusrc ? immg_source : reg_source2;

    // Model ALU for assertations
    // Onlt Shift right arithmetic fails, but we might remove it anyway
    task compute_alu();
        unique case(instruction)
            ALU_ADD:  expected = reg_source1 + second_operand;
            ALU_SUB:  expected = reg_source1 - second_operand;
            ALU_AND:  expected = reg_source1 & second_operand;
            ALU_OR:   expected = reg_source1 | second_operand;
            ALU_XOR:  expected = reg_source1 ^ second_operand;
            ALU_EQ:   expected = reg_source1 == second_operand;
            ALU_SLT:  expected = $signed(reg_source1) < $signed(reg_source1);
            ALU_SLTU: expected = reg_source1 < second_operand;
            ALU_SLL:  expected = reg_source1 << second_operand;
            ALU_SRL:  expected = reg_source1 >> second_operand;
            ALU_SRA:  expected = $signed(reg_source1) >>> second_operand;
            default: expected = 'x;
        endcase
    endtask
    
    // Compute result of model ALU when the DUT ALU output is modified
    always @(reg_destiny) compute_alu();
    assert property (@(posedge clk)expected == reg_destiny);
    
    initial begin
        repeat(50) begin
            // Randomize inputs and wait a clock cycle before proceeding
            std::randomize(reg_source1, reg_source2, immg_source, alusrc, instruction);
            @(posedge clk);
        end
        $finish;
    end
endmodule
