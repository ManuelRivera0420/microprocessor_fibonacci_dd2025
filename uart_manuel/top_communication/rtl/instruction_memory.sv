`timescale 1ns / 1ps
module instruction_memory #(
    parameter DATA_WIDTH = 32,      // Ancho de instruccion 
    parameter ADDR_WIDTH = 32,      // Ancho de dirección del PC
    parameter BYTE_WIDTH = 8,       // Ancho de cajón de la memoria (1 Byte)
    parameter MEM_DEPTH  = 1024      // Numero de renglones de memoria
)
(
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [ADDR_WIDTH-1:0] a,        // Dirección de lectura (PC 32 bits)
    output logic [DATA_WIDTH-1:0] rd,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
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
    end

    // 2. Escritura con la FIFO sincrona
    always_ff @(posedge clk) begin
        if (we) begin
            // Big Endian: Guardamos los 4 bytes en orden
            mem[dir]     <= data_in[31:24];
            mem[dir + 1] <= data_in[23:16]; 
            mem[dir + 2] <= data_in[15:8]; 
            mem[dir + 3] <= data_in[7:0]; 
        end
    end

    // 3. Lectura (Combinacional)
    assign rd = mem[a[DATA_WIDTH-1:2]];         // PC lee el programa

endmodule