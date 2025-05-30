module data_mem (
    input wire clk,
    input wire rst,

    // 写端口
    input wire mem_we_i,                   // 写使能
    input wire mem_req_i,                  // 写请求
    input wire [31:0] mem_waddr_i,         // 写地址
    input wire [31:0] mem_wdata_i,         // 写数据

    // 读端口
    input wire [31:0] mem_raddr_i,         // 读地址
    output reg [31:0] mem_rdata_o          // 读数据输出
);

    // 内存空间定义：2048 个 32-bit 字
    reg [31:0] mem [0:2047];

    initial begin
        // 初始化内存内容
        $readmemh("data_mem.txt", mem); // 从文件中读取数据
    end

    // 写操作：时序逻辑
    always @(posedge clk) begin
        if (rst && mem_req_i && mem_we_i) begin
            mem[mem_waddr_i[12:2]] <= mem_wdata_i;
        end
    end

    // 读操作：组合逻辑
    always @(*) begin
        if (rst) begin
            mem_rdata_o = mem[mem_raddr_i[12:2]];
        end else begin
            mem_rdata_o = 32'b0;
        end
    end

    // 调试：输出前 20 个单元
    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin : debug_block
            wire [31:0] debug_mem_i = mem[i];
        end
    endgenerate

endmodule
