module stall_control (
    input wire clk,
    input wire rst,
    input wire stall_req,   // 来自 hazard_detect_unit 的暂停请求
    output reg stall        // 全局 stall 信号
);

    reg [1:0] stall_counter;

    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            stall_counter <= 2'b00;
        end else if (stall_req && stall_counter == 0) begin
            // 检测到冒险，当前周期stall，下一周期再stall一次
            stall_counter <= 2'b01;  // 只再多暂停一个周期
        end else if (stall_counter > 0) begin
            stall_counter <= stall_counter - 1;
        end
    end

    // stall 是组合逻辑，确保当前周期 stall_req 立即触发暂停
    always @(*) begin
        if (stall_req || stall_counter > 0)
            stall = 1'b1;
        else
            stall = 1'b0;
    end

endmodule
