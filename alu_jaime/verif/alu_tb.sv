`timescale 1ns / 1ps

module alu_tb #(parameter N = 8)();
    bit clk;
    logic [N-1:0] reg_source1;
    logic [N-1:0] reg_source2;
    logic [N-1:0] immg_source;
    logic alusrc;
    logic [3:0]   instruction;
    logic [N-1:0] reg_destiny;
    
    logic [N-1:0] second_operand;
    logic [N-1:0] expected;

    localparam ADD  = 4'b0000; // Addition
    localparam SUB  = 4'b0001; // Substraction
    localparam AND  = 4'b0010; // Bitwise AND
    localparam OR   = 4'b0011; // Bitwise OR
    localparam XOR  = 4'b0100; // Bitwise XOR
    localparam EQ   = 4'b0101; // Set if equal
    localparam SLT  = 4'b0110; // Set if Less Than
    localparam SLTU = 4'b1000; // Set if Less that unsigned
    localparam SLL  = 4'b1001; // Shift Left Logic
    localparam SRL  = 4'b1010; // Shift Right Logic
    localparam SRA  = 4'b1011; // Shift Right Arithmetic

    alu #(.N(N)) DUT (
        .reg_source1(reg_source1),
        .reg_source2(reg_source2),
        .immg_source(immg_source),
        .alusrc(alusrc),
        .instruction(instruction),
        .reg_destiny(reg_destiny)
    );
    
    // Clock just for convenience, not really used
    initial clk = 0;
    always #5ns clk = ~clk;
    assign second_operand = alusrc ? reg_source2 : immg_source;

    // Model ALU for assertations
    task compute_alu();
        unique case(instruction)
            ADD:  expected = reg_source1 + second_operand;
            SUB:  expected = reg_source1 - second_operand;
            AND:  expected = reg_source1 & second_operand;
            OR:   expected = reg_source1 | second_operand;
            XOR:  expected = reg_source1 ^ second_operand;
            EQ:   expected = reg_source1 == second_operand;
            SLT:  expected = $signed(reg_source1) < $signed(reg_source1);
            SLTU: expected = reg_source1 < second_operand;
            SLL:  expected = reg_source1 << second_operand;
            SRL:  expected = reg_source1 >> second_operand;
            SRA:  expected = $signed(reg_source1) >>> second_operand;
            default: expected = 'x;
        endcase
    endtask
    
    always @(reg_destiny) compute_alu();        // Compute result of model ALU when the RTL ALU is modified
    assert property (@(posedge clk)expected == reg_destiny);    // Assert that both ALU have the same result
    
    initial begin
        repeat(50) begin
            std::randomize(reg_source1, reg_source2, immg_source, alusrc, instruction);
            @(posedge clk);
        end
        $finish;
    end
endmodule
