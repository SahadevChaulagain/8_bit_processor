module alu (
    input [7:0] op1,
    input [7:0] op2,
    input [3:0] opcode,
    output reg [7:0] result,
    output reg carry_flag,
    output reg zero_flag
);
    always @(*) begin
        carry_flag = 0;
        result = 8'h00;

        case (opcode)
            4'b0000, 4'b0110: {carry_flag, result} = op1 + op2;      // ADD and ADDI
            4'b0001: {carry_flag, result} = op1 - op2;               // SUB
            4'b0010: result = op1 & op2;                             // AND
            4'b0011: result = op1 | op2;                             // OR
            4'b0100: result = op1 ^ op2;                             // XOR
            4'b0101: begin                                           // NOT
                result = ~op1;
                carry_flag = 0;
            end
            default: result = 8'h00;
        endcase

        zero_flag = (result == 8'b00000000);
    end
endmodule
