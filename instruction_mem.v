module instruction_mem (
    input wire [31:0] address_i,
    output reg [31:0] instruction_o
);

    reg [31:0] instruction_mem [0:511]; // 支持 512 条指令

    initial begin
         $readmemh("inst_mem.txt", instruction_mem);
    end

    always @(*) begin
        instruction_o = instruction_mem[address_i[10:2]];  // 512 条指令 => 用 9 位地址 => address[10:2]
    end

endmodule
