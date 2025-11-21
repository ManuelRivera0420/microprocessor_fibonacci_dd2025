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
    input logic [31:0] imm32_branch,//Señal del orden y signo extendido
    input logic [31:0] alu_res,//dependiendo de lo que se quiera puede ser Equal o Less Than o less than unsigned en el LSB del resultado de la ALU
    input logic branch,  //Salida de Unidad de control para saber si se ocupara el valor de salida de la ALU
    input logic br_neg,  //Se ocupara el not if equal o el greater then or equal o unsigned
    output logic [31:0] pc_out //salida del program counter, tamaño para 2^32 instrucciones
    );
    localparam PC_INCREMENT = 4;//Incremento de 4 bytes para cada instrucción
    logic alu_res_final; //Salida de mux para control negacion de la alu
    logic branch_final; //salida de mux para controlar el branch

    //Registro para contador
    always_ff@(posedge clk, negedge arst_n)begin
        if(!arst_n)begin
            pc_out <= 32'd0;
        end else if(branch_final)begin //MUX para dejar pasar señal inmediata o +4
            pc_out <= pc_out + imm32_branch;//Al program counter se le suma el valor inmediato
        end else begin
            pc_out <= pc_out + PC_INCREMENT; //Progam counter funciona normal y se aplica +4
        end 
    end
    //Logica combinacional para salidas de unidad de control
    //Se toma el LSB de la alu para saber si rs1 y rs2 son == 0 < o >
    //La unidad de control indica si es la negación de la operación
    assign alu_res_final = br_neg ? ~alu_res[0] : alu_res[0];
    //Se usa para determinar si se usa el valor de salida de la alu
    assign branch_final = branch & alu_res_final;
endmodule
