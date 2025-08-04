module control_unit (
    input [3:0] opcode,
    output reg alu_enable,
    output reg reg_write,
    output reg acc_write,
    output reg mem_read,
    output reg mem_write,
    // output reg is_load,
    output reg is_store,
    output reg is_mov,
    output reg is_store_imm,
    output reg use_immediate
);
    always @(*) begin
        alu_enable    = 0;
        reg_write     = 0;
        acc_write     = 0;
        mem_read      = 0;
        mem_write     = 0;
        // is_load       = 0;
        is_store      = 0;
        is_mov        = 0;
        is_store_imm  = 0;
        use_immediate = 0;

        case (opcode)
            4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101: begin // ALU operations
                alu_enable = 1;
                acc_write  = 1;
            end
            4'b0110: begin // ADDI - ADD Immediate (using accumulator)
                alu_enable    = 1;
                acc_write     = 1;
                use_immediate = 1;
            end
            4'b0111: begin // LOAD memory to accumulator
                mem_read  = 1;
                acc_write = 1;
            end
            4'b1000: begin // MOV immediate to register
                is_mov        = 1;
                reg_write     = 1;
                use_immediate = 1;
                alu_enable    = 0; // no ALU operation needed
            end
            4'b1001: begin // STORE_IMM immediate value to memory
                is_store_imm = 1;
                mem_write    = 1;
            end
            4'b1010: begin // STORE accumulator to memeory
                mem_write = 1;
                is_store  = 1;
            end
            default: begin
                // Do nothing, all zero
            end
        endcase
    end
endmodule
