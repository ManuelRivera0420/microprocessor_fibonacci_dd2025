module instruction_memory (
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [31:0] a,        // Dirección de lectura (PC)
    output logic [31:0] rd,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
    input logic [31:0] data_in,  // Dato (instruccion) que viene de la FIFO
    input logic [7:0] dir,      // Dirección donde la FIFO quiere escribir
    input logic        we        // Write Enable (1 = Grabar dato)
);

    // Memoria de 32 bits y 8 renglones (instrucciones)
    logic [7:0] mem [0:255]; 

    // 1. Inicialización (limpieza)
    initial begin
        for (int i=0; i<256; i++) 
            mem[i] = 8'b0;
    end

    // 2. Escritura con la FIFO sincrona
    always_ff @(posedge clk) begin
        if (we) begin
            // Discrimina los 2 bits menos significativos "como si fuera división entre 4", y asi indicamos que reglon (instruccion) se está
            mem[dir] <= data_in[31:24];      // Si viene por byte (4 en4) "dir[31:2]", si viene de 1 en 1 "mem[dir]"
            mem[dir + 1] <= data_in[23:16]; 
            mem[dir + 2] <= data_in[15:8]; 
            mem[dir + 3] <= data_in[7:0]; 
        end
    end

    // 3. Lectura (Combinacional)
    assign rd = mem[a[31:2]];               // PC lee el programa

endmodule