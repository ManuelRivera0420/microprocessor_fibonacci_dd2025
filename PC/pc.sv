`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2025 15:22:32
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input logic clk,   //reloj del sistema 
    input logic arst_n,  //variable para resetear el contador
    input logic [31:0] inmediate,
    input logic [31:0] alu_res,//dependiendo de lo que se quiera puede ser Equal o Less Than o less than unsigned en el LSB del resultado de la ALU
    input logic branch,  //Salida de Unidad de control para saber si se ocupara el valor de salida de la ALU
    input logic br_neg,  //Se ocupara el not if equal o el greater then or equal o unsigned
    output logic [31:0] pc_out //salida del program counter, tamaño para 2^32 instrucciones
    );
    localparam PC_INCREMENT = 4;//Incremento de 4 bytes para cada instrucción
    logic alu_res_final;
    logic branch_final;
    logic [31:0] branch_offset;
    logic [4:0] inmediate_1;  //[11:7] |4|3|2|1|11| Parte 1 del valor intermedio  concatenar en uno mismo los dos
    logic [6:0] inmediate_2; // [31:25]     Parte 2 del valor intermedio
    //Se asignan los valores inmediatos a dos vectores
    assign inmediate_1[4:0]=inmediate[11:7];
    assign inmediate_2[6:0]=inmediate[31:25];
    //Registro para contador
    always_ff@(posedge clk, negedge arst_n)begin
        if(!arst_n)begin
            pc_out <= 32'd0;
        end else if(branch_final)begin //MUX para dejar pasar señal inmediata o +4
            pc_out <= pc_out + branch_offset;//Al program counter se le suma el valor intermedio
        end else begin
            pc_out <= pc_out + PC_INCREMENT; //Progam counter funciona normal y se aplica +4
        end 
    end
    //Logica para MUX con entrada de branch
    always_comb begin
        if(br_neg)begin//Si la salida de negación del branch esta en 1 la salida de la alu se invierte
            alu_res_final = ~alu_res[0];
        end else begin//Si esta en 0 se mantiene
            alu_res_final = alu_res[0];
        end
    end
    //and para determinar si se usara el branch
    assign branch_final = branch & alu_res_final;
    //inmediate_2[31:25] |12|10|9|8|7|6|5|
    //inmediate_1[11:7]  |4|3|2|1|11|
    //Concatenación de bits en branch offset
    assign branch_offset = {
        // [31:13] Extensión de Signo (20 copias del Imm[12])
        {20{inmediate_2[6]}},
        // [12:1] Los 12 bits de desplazamiento
        inmediate_2[6],      
        inmediate_1[0],       
        inmediate_2[5:0],  
        inmediate_1[4:1],           
        1'b0 // El primer bit siempre es 0
    };
endmodule
