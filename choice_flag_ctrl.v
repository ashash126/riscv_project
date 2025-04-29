module choice_flag_ctrl (
    input wire clk,
    input wire rst,
    input wire stall_i, // 流水线暂停信号
    output reg choice_flag_o // 选择是否使用lr的值
);

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            choice_flag_o <= 1'b0; // 默认不使用lr的值
        end else if (stall_i) begin
            choice_flag_o <= 1'b1; // 流水线暂停时使用lr的值
        end else begin
            choice_flag_o <= 1'b0; // 正常情况下不使用lr的值
        end
    end

endmodule