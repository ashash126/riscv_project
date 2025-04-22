module instruction_mem (
    input wire [31:0] address_i,
    output reg [31:0] instruction_o
);

    reg [31:0] instruction_mem [0:31]; // 32 x 32-bit instruction memory

    initial begin
         $readmemh("inst_mem.txt", instruction_mem);
    end

    always @(*) begin
        instruction_o = instruction_mem[address_i[6:2]];
    end

endmodule
