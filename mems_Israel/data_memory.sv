module Data_Memory (
    input logic clk,
    input logic we,             // Write Enable
    input logic [31:0] add,       // Address
    input logic [31:0] wd,      // Write Data
    output logic [31:0] rd      // Read Data
);

    logic [31:0] ram [0:63]; 

    // Lectura combinacional
    assign rd = ram[a[31:2]];

    // Escritura secuencial
    always_ff @(posedge clk) begin
        if (we) begin
            ram[a[31:2]] <= wd;
        end
    end

endmodule