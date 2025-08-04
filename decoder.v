module decoder (
    input [19:0] instruction,
    output [3:0] opcode,
    output [7:0] operand1,
    output [7:0] operand2
);
    assign opcode   = instruction[19:16];
    assign operand1 = instruction[15:8];
    assign operand2 = instruction[7:0];
endmodule
