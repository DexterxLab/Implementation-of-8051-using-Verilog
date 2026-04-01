
module alu(
    input [4:0] opcode,
    input [7:0] A, B,
    input CY_in,  // ✅ 1-bit
    output reg [7:0] result,
    output reg CY, AC, OV, Z
);

always @(*) begin
    result = 8'b0;
    CY = 0; AC = 0; OV = 0; Z = 0;
    
    case(opcode)
        5'b00000: begin // ADD
            {CY, result} = A + B;
            AC = (A[3:0] + B[3:0] > 4'hF);
            OV = (~A[7] & ~B[7] & result[7]) | (A[7] & B[7] & ~result[7]);
            Z = (result == 8'b0);
        end

        5'b00001: begin // ADDC
            {CY, result} = A + B + CY_in;  // ✅ consistent
            AC = (A[3:0] + B[3:0] + CY_in > 4'hF);  // ✅ include CY_in
            OV = (~A[7] & ~B[7] & result[7]) | (A[7] & B[7] & ~result[7]);
            Z = (result == 8'b0);
        end

        5'b00010: begin // SUB
            {CY, result} = A - B;  // CY = borrow
            OV = (A[7] & ~B[7] & ~result[7]) | (~A[7] & B[7] & result[7]);
            Z = (result == 8'b0);
        end

        5'b00011: begin // SUBB
            {CY, result} = A - B - CY_in;
            OV = (A[7] & ~B[7] & ~result[7]) | (~A[7] & B[7] & result[7]);
            Z = (result == 8'b0);
        end

        5'b00100: begin // AND
            result = A & B;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end

		5'b00101: begin // OR
            result = A | B;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end

		5'b00111: begin // XOR
            result = A ^ B;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end
		
		5'b01000: begin // NOT
            result = ~A;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end
		
		5'b01001: begin // INC
            result = A + 1;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end
		
		5'b01011: begin // DEC
            result = A - 1;
            Z = (result == 8'b0); CY = 0; OV = 0; AC = 0;
        end
		 // 4'b0010: result = (OperandB != 0) ? OperandA / OperandB : 8'b0;
        // 4'b0011: result = OperandA * OperandB;
        default: result = 8'b0;
    endcase
end
endmodule