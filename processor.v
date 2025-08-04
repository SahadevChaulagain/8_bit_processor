module processor (
    input clk,
    input reset
);
    reg [3:0] pc;
    reg [7:0] accumulator;
    reg [19:0] instruction_reg;
    reg [2:0] state;

    parameter FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, WRITEBACK = 3'b011;

    wire [19:0] instruction;
    wire [3:0] opcode;
    wire [7:0] operand1, operand2;
    wire [7:0] alu_result, reg_data_out, mem_data_out;
    wire carry_flag, zero_flag;
    wire [7:0] reg0, reg1, reg2;
    wire [1:0] reg_sel = operand1[1:0];

    wire alu_enable, reg_write, acc_write, mem_read, mem_write;
    wire is_store, is_mov, is_store_imm;
    wire use_immediate;

    program_memory pm(pc, instruction);

    decoder dec(instruction_reg, opcode, operand1, operand2);

    control_unit cu(opcode, alu_enable, reg_write, acc_write, mem_read, mem_write,
                    is_store, is_mov, is_store_imm, use_immediate);

    wire [7:0] alu_op2 = use_immediate ? operand1 : reg_data_out;

    alu alu_unit(accumulator, alu_op2, opcode, alu_result, carry_flag, zero_flag);

    wire [7:0] reg_write_data = is_mov ? operand2 : alu_result;

    register_file rf(
        clk,
        reg_write && (state == WRITEBACK),
        reg_sel,
        reg_write_data,
        reg0, reg1, reg2,
        reg_data_out
    );

    data_memory dm(
        clk,
        mem_read,
        mem_write,
        operand1,
        is_store_imm ? operand2 : accumulator,
        mem_data_out
    );

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= FETCH;
        pc <= 4'b0;
        instruction_reg <= 20'b0;
        accumulator <= 8'b0;
    end else begin
        case (state)
            FETCH: begin
                instruction_reg <= instruction;
                state <= DECODE;
            end
            DECODE: begin
                state <= EXECUTE;
            end
            EXECUTE: begin
                if (acc_write && !mem_read)
                    accumulator <= alu_result;
                state <= WRITEBACK;
            end
            WRITEBACK: begin
                if (mem_read)
                    accumulator <= mem_data_out;

                pc <= pc + 1;
                state <= FETCH;
            end
        endcase
    end
end

endmodule