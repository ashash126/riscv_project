// `timescale 1ns/1ps
// `include "defines.v"

// module tb_tinyriscv;

//     reg clk;
//     reg rst;

//     // 实例化 DUT
//     tinyriscv uut (
//         .clk(clk),
//         .rst(rst)
//     );

//     // 时钟生成：10ns周期 => 100MHz
//     always #5 clk = ~clk;

//     initial begin
//         $display("Starting tinyriscv simulation...");

//         // 初始化
//         clk = 0;
//         rst = 0;

//         // 加载指令存储器内容
//        // $readmemh("inst_mem.txt", uut.u_instruction_mem.instruction_mem);

//         // 加载数据存储器内容
//         //$readmemh("data_mem.txt", uut.u_data_mem.data_mem);

//         // 启动波形记录
//         $dumpfile("waveform.vcd");              // 输出文件名
//         $dumpvars(0, tb_tinyriscv);             // 从顶层记录所有变量
//         //$dumpvars(0, uut.u_regs);           // ✅ 添加这一行：记录32个通用寄存器

//         // 释放复位
//         #20;
//         rst = 1;

//         // 模拟运行 10000ns 后结束
//         #10000;
//         $finish;
//     end

// endmodule


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

    // 声明文件句柄
    integer file;

    // 监控信号
    initial begin
        $display("Starting tinyriscv simulation...");

        // 初始化
        clk = 0;
        rst = 0;

        // 打开文件用于输出寄存器 x26 和 x27 的值
        file = $fopen("reg_values.txt", "w");

        // 启动波形记录
        //$dumpfile("waveform.vcd");              // 输出文件名
        //$dumpvars(0, tb_tinyriscv);             // 从顶层记录所有变量

        // 释放复位
        #20;
        rst = 1;

        // 仿真运行10000ns后结束
        #10000;
        $finish;

        // 关闭文件
        $fclose(file);
    end

    // 在时钟上每个周期检查并输出寄存器值
    always @(posedge clk) begin
        // 输出时间戳和寄存器的值到文件
        $fdisplay(file, "Time: %t | reg_26: %h | reg_27: %h", $time, uut.u_regs.reg_26, uut.u_regs.reg_27);
    end

endmodule
