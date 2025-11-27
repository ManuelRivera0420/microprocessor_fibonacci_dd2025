`timescale 1ns / 1ps
module instruction_memory #(
    parameter BYTE_WIDTH = 8,       // Ancho de cajón de la memoria (1 Byte)
    parameter MEM_DEPTH  = 1024,      // Numero de renglones de memoria
    parameter ADDR_WIDTH = 10,      // con 10 bits podemos direccionar 1024 renglones
    parameter DATA_WIDTH = 32      // Ancho de instruccion (La instrucción completa mide 32 bits)
)
(
    input logic clk,
    
    // Puerto de Lectura (PC)
    input  logic [ADDR_WIDTH-1:0] rd_addr,        // Dirección de lectura (PC 32 bits)
    output logic [DATA_WIDTH-1:0] rd_data,       // Instrucción que sale
    
    // Puerto de escritura (FIFO)
    input logic [DATA_WIDTH-1:0] data_in,   // Dato (instruccion) que viene de la FIFO
    input logic [ADDR_WIDTH-1:0] wr_addr,   // Dirección (10 bits para 1024 espacios)
    input logic w_en                        // Write Enable
);

    localparam BANK_DEPTH = MEM_DEPTH / 4; // 256 renglones por banco
    logic [BYTE_WIDTH-1:0] bank0 [0:BANK_DEPTH-1]; // Byte 3 guarda [31:24]
    logic [BYTE_WIDTH-1:0] bank1 [0:BANK_DEPTH-1]; // Byte 2 guarda [23:16]
    logic [BYTE_WIDTH-1:0] bank2 [0:BANK_DEPTH-1]; // Byte 1 guarda [15:8]
    logic [BYTE_WIDTH-1:0] bank3 [0:BANK_DEPTH-1]; // Byte 0 guarda [7:0]
    

    // 1. Inicialización (Limpieza de los 4 bancos)
    initial begin
        for (int i=0; i<BANK_DEPTH; i++) begin
            bank0[i] = {BYTE_WIDTH{1'b0}};
            bank1[i] = {BYTE_WIDTH{1'b0}};
            bank2[i] = {BYTE_WIDTH{1'b0}};
            bank3[i] = {BYTE_WIDTH{1'b0}};
        end
    end

    // 2. Escritura paralea en los 4 bancos
    // [9:2] para elegir el renglón dentro del banco
    always_ff @(posedge clk) begin
        if (w_en) begin
            bank3[wr_addr[ADDR_WIDTH-1:2]] <= data_in[31:24]; // MSB al final
            bank2[wr_addr[ADDR_WIDTH-1:2]] <= data_in[23:16];
            bank1[wr_addr[ADDR_WIDTH-1:2]] <= data_in[15:8];
            bank0[wr_addr[ADDR_WIDTH-1:2]] <= data_in[7:0];   // LSB al inicio
        end
    end

    // 3. Lectura (Combinacional)
    // Leemos de los 4 bancos al mismo tiempo y pegamos el resultado
    assign rd_data = {bank3[rd_addr[ADDR_WIDTH-1:2]], bank2[rd_addr[ADDR_WIDTH-1:2]], bank1[rd_addr[ADDR_WIDTH-1:2]], bank0[rd_addr[ADDR_WIDTH-1:2]]};
endmodule