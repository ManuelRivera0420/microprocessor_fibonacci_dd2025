`timescale 1ns / 1ps
module tb_instruction_memory();

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;
    parameter BYTE_WIDTH = 8;
    parameter MEM_DEPTH  = 1024;
    
    // Lectura
    logic [ADDR_WIDTH-1:0] a;       // Dirección de Lectura (32 bits)
    logic [DATA_WIDTH-1:0] rd;      // Dato Leído (32 bits)
    
    //Escritura
    logic [9:0] dir;                // Dirección de Escritura (10 bits)
    logic [DATA_WIDTH-1:0] data_in; // Dato de Escritura (32 bits)
    logic we;
    logic clk;

    
    instruction_memory #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.BYTE_WIDTH(BYTE_WIDTH),.MEM_DEPTH(MEM_DEPTH)) 
    dut (.clk(clk),.a(a),.rd(rd),.data_in(data_in),.dir(dir),.we(we));
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10ns
    end
    
    // Lista de instrucciones FIBO a cargar
 logic [31:0] instr_mem [0:9] = '{
    32'h00000513, // I-type
    32'h00100593, // I-type
    32'h00A00613, // I-type
    32'h00060C63, // B-type
    32'h00B502B3, // R-type
    32'h00B00533, // R-type
    32'h005005B3, // R-type
    32'hFFF60613, // I-type
    32'hFEDFF06F, // J-type largo
    32'h0000006F  // JAL
};
  
    initial begin
    // 1. INICIALIZACIÓN
        we = '0; dir = '0; data_in = '0; a = '0;
        $display("-----INICIO DE SIMULACION-----");
        #5;   
    // 2. Escritura
        $display("-----ESCRITURA DE MEMORIA-----");
        for (int i=0; i<10; i++) begin
            @(posedge clk);
            we = 1;
            dir = i * 4; // escribe en 0, 4, 8, 12...
            data_in = instr_mem[i];
            @(posedge clk);
            we = 0;
        end
    // 3. Lectura
        for (int i=0; i<10; i++) begin
            a = i * 4; // El PC pide dirección 0, 4, 8...
            rd = instr_mem[i];
            #20;
        end
        #5;
        $finish;
    end

endmodule
