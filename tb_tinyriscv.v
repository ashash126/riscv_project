`timescale 1ns/1ps
`include "defines.v"

module tb_tinyriscv;

    reg clk;
    reg rst;

    // 实例化 DUT
    tinyriscv uut (
        .clk(clk),
        .rst(rst)
    );

    // 时钟生成：10ns周期 => 100MHz
    always #5 clk = ~clk;

    initial begin
        $display("Starting tinyriscv simulation...");

        // 初始化
        clk = 0;
        rst = 0;

        // 加载指令存储器内容
       // $readmemh("inst_mem.txt", uut.u_instruction_mem.instruction_mem);

        // 加载数据存储器内容
        //$readmemh("data_mem.txt", uut.u_data_mem.data_mem);

        // 启动波形记录
        $dumpfile("waveform.vcd");              // 输出文件名
        $dumpvars(0, tb_tinyriscv);             // 从顶层记录所有变量
        //$dumpvars(0, uut.u_regs);           // ✅ 添加这一行：记录32个通用寄存器

        // 释放复位
        #20;
        rst = 1;

        // 模拟运行 500ns 后结束
        #10000;
        $finish;
    end

endmodule
