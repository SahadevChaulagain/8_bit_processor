module register_file (
    input clk,
    input reg_write,
    input [1:0] reg_sel,
    input [7:0] data_in,
    output reg [7:0] reg0,
    output reg [7:0] reg1,
    output reg [7:0] reg2,
    output reg [7:0] selected_out
);

    always @(posedge clk) begin
        if (reg_write) begin
            case (reg_sel)
                2'b00: reg0 <= data_in;
                2'b01: reg1 <= data_in;
                2'b10: reg2 <= data_in;
                default: ;
            endcase
        end
    end

    always @(*) begin
        case (reg_sel)
            2'b00: selected_out = reg0;
            2'b01: selected_out = reg1;
            2'b10: selected_out = reg2;
            default: selected_out = 8'b0;
        endcase
    end

endmodule