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

    // 1. Inicialización (Limpieza)
    initial begin
        for (int i=0; i<7; i++) 
            ram[i] = 32'b0;
    end
    
    // Escritura debe de ser secuencial
    always_ff @(posedge clk) begin
        if (we) begin
            ram[a[31:2]] <= di;         //si WE es 1, se escribe en la ram el valor
        end
    end

endmodule