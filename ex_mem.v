`include "defines.v"

// EX-MEM 流水寄存器
module ex_mem(
    input wire clk,
    input wire rst,

    input wire[`InstBus] inst_i,            // 指令内容 从指令存储器传入
    input wire[`InstAddrBus] inst_addr_i,   // 指令地址 

    input wire[`RegBus] reg_wdata_i,        // 写通用寄存器数据
    input wire reg_we_i,                    // 写通用寄存器标志 
    input wire[`RegAddrBus] reg_waddr_i,    // 写通用寄存器地址

    input wire[`InstAddrBus]op1_add_op2_res_i, // ALU运算结果
    input wire [1:0]mem_raddr_index_i, // 读地址索引
    input wire [1:0]mem_waddr_index_i, // 写地址索引    

    input wire[`RegBus] reg2_rdata_i,        // 读寄存器2数据   

    output reg[`InstBus] inst_o,            // 指令内容
    output reg[`InstAddrBus] inst_addr_o,   // 指令地址

    output reg[`RegBus] reg_wdata_o,        // 写通用寄存器数据
    output reg reg_we_o,                    // 写通用寄存器标志
    output reg[`RegAddrBus] reg_waddr_o,     // 写通用寄存器地址

    output reg[`InstAddrBus]op1_add_op2_res_o, // ALU运算结果
    output reg [1:0]mem_raddr_index_o, // 读地址索引
    output reg [1:0]mem_waddr_index_o, // 写地址索引

    output reg[`RegBus] reg2_rdata_o        // 读寄存器2数据
);

always @(posedge clk or posedge rst) begin
    if (!rst) begin
        inst_o       <= `INST_NOP;
        inst_addr_o  <= `ZeroWord;
        reg_wdata_o  <= `ZeroWord;
        reg_we_o     <= `WriteDisable;
        reg_waddr_o  <= `ZeroReg;
        op1_add_op2_res_o <= `ZeroWord;
        mem_raddr_index_o <= 2'b00;
        mem_waddr_index_o <= 2'b00;
        reg2_rdata_o <= `ZeroWord;
    end else begin
        inst_o       <= inst_i;
        inst_addr_o  <= inst_addr_i;
        reg_wdata_o  <= reg_wdata_i;
        reg_we_o     <= reg_we_i;
        reg_waddr_o  <= reg_waddr_i;
        op1_add_op2_res_o <= op1_add_op2_res_i;
        mem_raddr_index_o <= mem_raddr_index_i;
        mem_waddr_index_o <= mem_waddr_index_i;
        reg2_rdata_o <= reg2_rdata_i;
    end
end

endmodule
