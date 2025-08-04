module program_memory (
    input [3:0] addr,
    output reg [19:0] instruction
);


    reg [19:0] memory [0:15];

    initial begin
        memory[0] = {4'b1000, 8'd0, 8'd10};     // MOV R0, 10
        memory[1] = {4'b1000, 8'd1, 8'd12};     // MOV R1, 12
        memory[2] = {4'b0000, 8'd0, 8'd0};      // ADD R0
        memory[3] = {4'b0110, 8'd5, 8'd0};      // ADDI 5
        memory[4] = {4'b1001, 8'd20, 8'd14};    // STORE_IMM MEM[20], 15
        memory[5] = {4'b0111, 8'd20, 8'd0};     // LOAD MEM[20]
        memory[6] = {4'b1000, 8'd21, 8'd2};     // STORE MEM[21]
    end

    always @(*) begin
        instruction = memory[addr];
    end
endmodule