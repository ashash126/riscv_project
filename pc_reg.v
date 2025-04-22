`include "defines.v"

module pc_reg(
    input wire clk,
    input wire rst,
    
    input wire jump_flag_i,
    input wire [`InstAddrBus] jump_addr_i, //31:0
    input wire [`Hold_Flag_Bus] hold_flag_i, //2:0

    output reg [`InstAddrBus] pc_o
);

    always @ (posedge clk) begin
        // 复位
        if (rst == `RstEnable ) begin // 1'b0
            pc_o <= `CpuResetAddr; //  32'b0
        // 跳转
        end else if (jump_flag_i == `JumpEnable) begin //1'b1
            pc_o <= jump_addr_i;
        // 暂停
        end else if (hold_flag_i >= `Hold_Pc) begin //3'b001
            pc_o <= pc_o;
        // 地址加4
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule   