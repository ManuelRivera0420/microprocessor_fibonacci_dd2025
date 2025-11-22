<<<<<<< HEAD
`timescale 1ns / 1ps
module instruction_memory #(
    parameter DATA_WIDTH = 32,      // Ancho de instruccion 
    parameter ADDR_WIDTH = 32,      // Ancho de dirección del PC
    parameter BYTE_WIDTH = 8,       // Ancho de cajón de la memoria (1 Byte)
    parameter MEM_DEPTH  = 256      // Numero de renglones de memoria
)
(
=======
module instruction_memory (
>>>>>>> e4c70c124b674d4676cc8de1d17407e18816b54b
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [ADDR_WIDTH-1:0] a,        // Dirección de lectura (PC 32 bits)
    output logic [DATA_WIDTH-1:0] rd,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
<<<<<<< HEAD
    input logic [DATA_WIDTH-1:0] data_in,   // Dato (instruccion) que viene de la FIFO
    input logic [BYTE_WIDTH-1:0]            dir,       // Dirección (8 bits para 256 espacios)
    input logic                  we         // Write Enable
);

    // Memoria de 1 byte y 256 renglones
    logic [BYTE_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // 1. Inicialización (limpieza)
    initial begin
        for (int i=0; i<MEM_DEPTH; i++) 
            mem[i] = {BYTE_WIDTH{1'b0}};
=======
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
>>>>>>> e4c70c124b674d4676cc8de1d17407e18816b54b
    end

    // 2. Escritura con la FIFO sincrona
    always_ff @(posedge clk) begin
        if (we) begin
<<<<<<< HEAD
            // Big Endian: Guardamos los 4 bytes en orden
            mem[dir]     <= data_in[31:24];
=======
            // Discrimina los 2 bits menos significativos "como si fuera división entre 4", y asi indicamos que reglon (instruccion) se está
            mem[dir] <= data_in[31:24];      // Si viene por byte (4 en4) "dir[31:2]", si viene de 1 en 1 "mem[dir]"
>>>>>>> e4c70c124b674d4676cc8de1d17407e18816b54b
            mem[dir + 1] <= data_in[23:16]; 
            mem[dir + 2] <= data_in[15:8]; 
            mem[dir + 3] <= data_in[7:0]; 
        end
    end

    // 3. Lectura (Combinacional)
    assign rd = {mem[a], mem[a+1], mem[a+2], mem[a+3]};         // PC lee el programa

endmodule