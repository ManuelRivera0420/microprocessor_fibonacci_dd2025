module Instruction_Memory (
    input  logic [31:0] add,    // Address (PC)
    output logic [31:0] rd    // Read Data (Instrucción)
);

    logic [31:0] rom [0:63]; // Espacio para 64 instrucciones

    initial begin
        // 1. Limpiar memoria
        for (int i=0; i<64; i++) rom[i] = 32'b0;

        // 2. Cargar programa Fibonacci (Binarios del equipo)
        rom[0] = 32'b00000000000000000000010100010011; // ADDI x10, x0, 0              Inicializa x10 en 0
        rom[1] = 32'b00000000000100000000010110010011; // ADDI x11, x0, 1              Inicializa x11 en 1
        rom[2] = 32'b00000000101000000000011000010011; // ADDI x12, x0, 10             Inicializa contador x12 en 10
        rom[3] = 32'b00000000101101010000010110110011; // ADD x11, x10, x11 (Fib)      Fibonacci: suma anterior + actual
        rom[4] = 32'b01000000101001011000010100110011; // SUB x10, x11, x10 (Swap)     Actualiza el viejo valor usando resta
        rom[5] = 32'b11111111111101100000011000010011; // ADDI x12, x12, -1 (Dec)      Resta 1 al contador x12
        rom[6] = 32'b11111110000001100001101011100011; // BNE x12, x0, -12 (Loop)      Si el contador x12 no es cero, salta 3 instrucciones atrás (a la línea 4)
        rom[7] = 32'b00000000000000000000000001101111; // JAL x0, 0 (Fin)              Fin, se queda en bucle infinito
    end

    // El PC va de 4 en 4 bytes, convertimos a indice de palabra (dividir por 4)
    assign rd = rom[add[31:2]];

endmodule