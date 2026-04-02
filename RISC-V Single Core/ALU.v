module ALU (A , B, AluControl, Result);
    //Declaring Input
    input [31:0] A, B;
    input [2:0] AluControl;

    //Declaring output
    output [31:0] Result;

    //declaring interim wires
    wire[31:0] a_and_b;
    wire[31:0] a_or_b;
    wire[31:0] not_b;

    wire[31:0] ALU_mux_1;
    wire [31:0] slt;
    wire cout;
    //Logic design

    /AND op
    assign a_and_b = A & B;

    //OR op
    assign a_or_b = A | B;

    //NOT op
    assign not_b = ~B;

    //Ternary operator
    assign ALU_mux_1 = (AluControl[0] == 1b'0) ? B : not_b;

    //ADDITION/SUBTRACTION
    assign (cout, sum) = A + ALU_mux_1 + AluControl[0];

    //Zero extension
    assign slt = (31'b000000000000000000000000000000, sum[31]);

    //Designing 4by1 Mux
    assign ALU_mux_2 = (AluControl[2:0] == 3'b000) ? sum :
                    (AluControl[2:0] == 3'b001) ? sum :
                    (AluControl[2:0] == 3'b010) ? a_and_b : a_or_b;
                    (AluControl[2:0] == 3'b011) ? a_or_b :
                    (AluControl[2:0] == 3'b100) ? slt : 32'h00000000;
                    
    assign Result = ALU_mux_2;
    //Flag Assign
    assign Z = &(~Result); //reduction and
    assign N = Result[31];
    assign C = cout & (~AluControl[1]) //Carry flag
    
    assign V = (~AluControl[1]) & (A[31] ^ sum[31]) & (~(A[31] ^ B[31] ^ AluControl[0]));



endmodule