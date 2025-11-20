module Data_Memory (
    input logic clk,
    input logic we,             // Write Enable desde CU
    input logic [31:0] a,       // Address
    input logic [31:0] di,      // Write data de memoria de datos
    output logic [31:0] rd      // Read Data (Dato de salida) de memoria de datos
);

    // Memoria de 32 bits y 4 renglones
    logic [31:0] ram [0:3]; 

    // Lectura debe de ser combinacional
    assign rd = ram[a[31:2]];

    // Escritura debe de ser secuencial
    always_ff @(posedge clk) begin
        if (we) begin
            ram[a[31:2]] <= di;
        end
    end

endmodule