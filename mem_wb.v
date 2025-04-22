`include "defines.v"

// EX-MEM 流水寄存器
module mem_wb(
    input wire clk,
    input wire rst,

    input wire [`RegBus] reg_wdata_i,       // 写通用寄存器数据
    input wire reg_we_i,                    // 写通用寄存器标志
    input wire [`RegAddrBus] reg_waddr_i,   // 写通用寄存器地址

    output reg [`RegBus] reg_wdata_o,       // 写通用寄存器数据
    output reg reg_we_o,                    // 写通用寄存器标志
    output reg [`RegAddrBus] reg_waddr_o   // 写通用寄存器地址

);

always @(posedge clk or posedge rst) begin
    if (!rst) begin
        reg_wdata_o <= `ZeroWord;
        reg_we_o    <= `WriteDisable;
        reg_waddr_o <= `ZeroReg;
    end else begin
        reg_wdata_o <= reg_wdata_i;
        reg_we_o    <= reg_we_i;
        reg_waddr_o <= reg_waddr_i;
    end
end

endmodule
