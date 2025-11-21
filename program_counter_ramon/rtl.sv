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
    //Se asignan los valores inmediatos a dos vectores

    //Registro para contador
    always_ff@(posedge clk, negedge arst_n)begin
        if(!arst_n)begin
            pc_out <= 32'd0;
        end else if(branch_final)begin //MUX para dejar pasar señal inmediata o +4
            pc_out <= pc_out + branch_offset;//Al program counter se le suma el valor inmediato
        end else begin
            pc_out <= pc_out + PC_INCREMENT; //Progam counter funciona normal y se aplica +4
        end 
    end
    //Logica para MUX con entrada de branch
    /*
    always_comb begin
        if(br_neg)begin//Si la salida de negación del branch esta en 1 la salida de la alu se invierte
            alu_res_final = ~alu_res[0];
        end else begin//Si esta en 0 se mantiene
            alu_res_final = alu_res[0];
        end
        
        if (branch)begin
            branch_final = alu_res_final;
        end else begin
            branch_final = '0;
         end
    end
    */
    assign alu_res_final = br_neg ? ~alu_res[0] : alu_res[0];
    assign branch_final = branch & alu_res_final;
    //and para determinar si se usara el branch
    //assign branch_final = branch & alu_res_final;
    //inmediate_2[31:25] |12|10|9|8|7|6|5|
    //inmediate_1[11:7]  |4|3|2|1|11|
    //Concatenación de bits en branch offset
    
    
    logic imm12;
    logic [5:0] imm10_5;
    logic [3:0] imm4_1;
    logic imm11;

    assign imm12   = inmediate[31];
    assign imm10_5 = inmediate[30:25];
    assign imm4_1  = inmediate[11:8];
    assign imm11   = inmediate[7];

    assign branch_offset = {
        {19{imm12}},
        imm12,
        imm11,
        imm10_5,
        imm4_1,
     1'b0//Siempre inicia con cero
    };

endmodule
