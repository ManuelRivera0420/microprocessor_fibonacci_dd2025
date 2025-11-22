module Data_Memory #(
    parameter DATA_WIDTH = 32,      // Ancho de instruccion / dato
    parameter ADDR_WIDTH = 32,      // Ancho de dirección del PC
    parameter MEM_DEPTH  = 4        // Profundidad (4 renglones: 0,1,2,3)
    )(

    input logic clk,
    input logic we,             // Write Enable desde CU
    input logic [ADDR_WIDTH-1:0] a,       // Address
    input logic [DATA_WIDTH-1:0] di,      // Write data de memoria de datos
    output logic [DATA_WIDTH-1:0] rd      // Read Data (Dato de salida) de memoria de datos
);

    // Memoria de 32 bits y 4 renglones
    logic [DATA_WIDTH-1:0] ram [0:MEM_DEPTH-1]; 

    // Lectura debe de ser combinacional
    assign rd = ram[a[ADDR_WIDTH-1:2]];

    // 1. Inicialización (Limpieza)
    initial begin
        for (int i=0; i<MEM_DEPTH; i++) 
            ram[i] = {DATA_WIDTH{1'b0}};
    end
    
    // Escritura debe de ser secuencial
    always_ff @(posedge clk) begin
        if (we) begin
            ram[a[ADDR_WIDTH-1:2]] <= di;         //si WE es 1, se escribe en la ram el valor
        end
    end

endmodule