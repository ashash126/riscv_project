module instruction_mem (
    input wire [31:0] address_i,
    output reg [31:0] instruction_o
);

    reg [31:0] instruction_mem [0:255]; // 支持 256 条指令

    initial begin
         $readmemh("inst_mem.txt", instruction_mem);
    end

    always @(*) begin
        instruction_o = instruction_mem[address_i[9:2]];  // 256 条指令 => 用 8 位地址 => address[9:2]
    end

endmodule
