module Instruction_Memory (
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [31:0] a,        // Dirección de lectura (PC)
    output logic [31:0] rd,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
    input logic [31:0] data_in,  // Dato (instruccion) que viene de la FIFO
    input logic [31:0] dir,      // Dirección donde la FIFO quiere escribir
    input logic        we        // Write Enable (1 = Grabar dato)
);

    // Memoria de 32 bits y 8 renglones (instrucciones)
    logic [31:0] mem [0:7]; 

    // 1. Inicialización (Limpieza)
    initial begin
        for (int i=0; i<7; i++) 
            mem[i] = 32'b0;
    end

    // 2. Escritura con la FIFO sincrona
    always_ff @(posedge clk) begin
        if (we) begin
            // Discrimina los 2 bits menos significativos
            mem[dir[31:2]] <= data_in;      // Si viene por byte (4 en4) "dir[31:2]", si viene de 1 en 1 "mem[dir]"
        end
    end

    // 3. Lectura (Combinacional)
    assign rd = mem[a[31:2]];               // PC lee el programa

endmodule