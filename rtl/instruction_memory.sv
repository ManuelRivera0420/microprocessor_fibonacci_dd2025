`timescale 1ns / 1ps
module instruction_memory #(
    parameter BYTE_WIDTH = 8,       // Ancho de cajón de la memoria (1 Byte)
    parameter MEM_DEPTH  = 1024,    // Número de renglones de memoria
    parameter ADDR_WIDTH = 10,      // con 10 bits podemos direccionar 1024 renglones
    parameter DATA_WIDTH = 32       // Ancho de instrucción (32 bits)
)
(
    input  logic                   clk,
    
    // Puerto de Lectura (PC)
    input  logic [ADDR_WIDTH-1:0]  rd_addr,   // Dirección de lectura (PC)
    output logic [DATA_WIDTH-1:0]  rd_data,   // Instrucción que sale
    
    // Puerto de escritura (FIFO)
    input  logic [DATA_WIDTH-1:0]  data_in,   // Dato (instrucción) que viene de la FIFO
    input  logic [ADDR_WIDTH-1:0]  wr_addr,   // Dirección (10 bits para 1024 espacios)
    input  logic                   w_en       // Write Enable
);

    localparam BANK_DEPTH = MEM_DEPTH / 4; // 256 renglones por banco

    // bank3 = byte [31:24] (MSB), bank0 = byte [7:0] (LSB)
    logic [BYTE_WIDTH-1:0] bank0 [0:BANK_DEPTH-1]; 
    logic [BYTE_WIDTH-1:0] bank1 [0:BANK_DEPTH-1]; 
    logic [BYTE_WIDTH-1:0] bank2 [0:BANK_DEPTH-1]; 
    logic [BYTE_WIDTH-1:0] bank3 [0:BANK_DEPTH-1]; 

    // 1. Inicialización (Limpieza + programa)
    initial begin : init_memory
        // Limpia toda la memoria
        for (int i = 0; i < BANK_DEPTH; i++) begin
            bank0[i] = {BYTE_WIDTH{1'b0}};
            bank1[i] = {BYTE_WIDTH{1'b0}};
            bank2[i] = {BYTE_WIDTH{1'b0}};
            bank3[i] = {BYTE_WIDTH{1'b0}};
        end

        // =========================================
        // Programa (10 instrucciones)
        // Cada instrucción está en formato:
        //   {bank3, bank2, bank1, bank0} = [31:24], [23:16], [15:8], [7:0]
        // =========================================

        // 0: 00000000000000000000010100010011 = 32'h00000513
        bank3[0] = 8'h00;
        bank2[0] = 8'h00;
        bank1[0] = 8'h05;
        bank0[0] = 8'h13;

        // 1: 00000000000100000000010110010011 = 32'h00100593
        bank3[1] = 8'h00;
        bank2[1] = 8'h10;
        bank1[1] = 8'h05;
        bank0[1] = 8'h93;

        // 2: 00000000101000000000011000010011 = 32'h00A00613
        bank3[2] = 8'h00;
        bank2[2] = 8'h90;
        bank1[2] = 8'h06;
        bank0[2] = 8'h13;       

        // 3: 00000000000001100000110001100011 = 32'h00060C63
        bank3[3] = 8'h00;
        bank2[3] = 8'h06;
        bank1[3] = 8'h0C;
        bank0[3] = 8'h63;

        // 4: 00000000101101010000001010110011 = 32'h00B502B3
        bank3[4] = 8'h00;
        bank2[4] = 8'hB5;
        bank1[4] = 8'h02;
        bank0[4] = 8'hB3;
        //    00000000000001011000010100010011 
        // 5: 00000000101100000000010100110011 = 32'h00B00533
        bank3[5] = 8'h00;
        bank2[5] = 8'h05;
        bank1[5] = 8'h85;
        bank0[5] = 8'h13;

        // 6: 00000000010100000000010110110011 = 32'h005005B3
        bank3[6] = 8'h00;
        bank2[6] = 8'h02;
        bank1[6] = 8'h85;
        bank0[6] = 8'h93;

        // 7: 11111111111101100000011000010011 = 32'hFFF60613
        bank3[7] = 8'hFF;
        bank2[7] = 8'hF6;
        bank1[7] = 8'h06;
        bank0[7] = 8'h13;

        // 8: 11111110110111111111000001101111 = 32'hFEDFF06F
        bank3[8] = 8'hFE;
        bank2[8] = 8'hDF;
        bank1[8] = 8'hF0;
        bank0[8] = 8'h6F;

        // 9: 00000000000000000000000001101111 = 32'h0000006F
        bank3[9] = 8'h00;
        bank2[9] = 8'h00;
        bank1[9] = 8'h00;
        bank0[9] = 8'h6F;
    end

    // 2. Escritura paralela en los 4 bancos
    // [ADDR_WIDTH-1:2] para elegir el renglón dentro del banco (PC alineado a 4 bytes)
    always_ff @(posedge clk) begin
        if (w_en) begin
            bank3[wr_addr[ADDR_WIDTH-1:2]] <= data_in[31:24]; // MSB
            bank2[wr_addr[ADDR_WIDTH-1:2]] <= data_in[23:16];
            bank1[wr_addr[ADDR_WIDTH-1:2]] <= data_in[15:8];
            bank0[wr_addr[ADDR_WIDTH-1:2]] <= data_in[7:0];   // LSB
        end
    end

    // 3. Lectura (Combinacional)
    assign rd_data = {
        bank3[rd_addr[ADDR_WIDTH-1:2]],
        bank2[rd_addr[ADDR_WIDTH-1:2]],
        bank1[rd_addr[ADDR_WIDTH-1:2]],
        bank0[rd_addr[ADDR_WIDTH-1:2]]
    };

endmodule
