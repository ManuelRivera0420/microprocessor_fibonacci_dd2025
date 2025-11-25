`timescale 1ns / 1ps
module instruction_memory #(
    parameter DATA_WIDTH = 32,      // Ancho de instruccion (La instrucción completa mide 32 bits)
    parameter ADDR_WIDTH = 32,      // Ancho de dirección del PC (El PC maneja direcciones de 32 bits)
    parameter BYTE_WIDTH = 8,       // Ancho de cajón de la memoria (1 Byte)
    parameter MEM_DEPTH  = 1024      // Numero de renglones de memoria
)
(
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [ADDR_WIDTH-1:0] rd_addr,        // Dirección de lectura (PC 32 bits)
    output logic [DATA_WIDTH-1:0] rd_data,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
    input logic [DATA_WIDTH-1:0] data_in,   // Dato (instruccion) que viene de la FIFO
    input logic [9:0] wr_aaddr,                  // Dirección (10 bits para 1024 espacios)
    input logic w_en         // Write Enable
);

    // Memoria de 1 byte y 1024 renglones
    logic [BYTE_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // 1. Inicialización (limpieza)
    initial begin
        for (int i=0; i<MEM_DEPTH; i++) 
            mem[i] = {BYTE_WIDTH{1'b0}};
    end

    // 2. Escritura con la FIFO sincrona
    always_ff @(posedge clk) begin
        if (w_en) begin
            // Big Endian: Guardamos los 4 bytes en orden
            mem[wr_aaddr]     <= data_in[31:24];
            mem[wr_aaddr + 1] <= data_in[23:16]; 
            mem[wr_aaddr + 2] <= data_in[15:8]; 
            mem[wr_aaddr + 3] <= data_in[7:0]; 
        end
    end

    // 3. Lectura (Combinacional)
    // Se concatena 4 bytes para construir la instruccion de 32bits
    // [9:0] para poder leer hasta 1024 renglones
    assign rd_data = {mem[rd_addr[9:0]], mem[rd_addr[9:0]+1], mem[rd_addr[9:0]+2], mem[rd_addr[9:0]+3]};         // PC lee el programa

endmodule

