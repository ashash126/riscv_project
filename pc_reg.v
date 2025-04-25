`include "defines.v"

module pc_reg(
    input wire clk,
    input wire rst,
    
    input wire jump_flag_i,
    input wire [`InstAddrBus] jump_addr_i, //31:0
    input wire stall_i, //暂停信号

    output reg [`InstAddrBus] pc_o
);

    always @ (posedge clk) begin
        // 复位
        if (rst == `RstEnable ) begin // 1'b0
            pc_o <= `CpuResetAddr; //  32'b0
        // 跳转
        end else if (jump_flag_i == `JumpEnable & stall_i == 0) begin //1'b1
            pc_o <= jump_addr_i;
        // 暂停
        end else if (stall_i == 1) begin //3'b001
            pc_o <= pc_o;
        // 地址加4
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule   