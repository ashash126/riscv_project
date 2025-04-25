module hazard_detect_unit (
    input wire rst,
    
    // ID阶段读寄存器地址
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    // EX阶段写寄存器地址及写使能
    input wire alu_reg_we,
    input wire [4:0] alu_reg_waddr,

    // MEM阶段写寄存器地址及写使能
    input wire mem_reg_we,
    input wire [4:0] mem_reg_waddr,

    // 输出：是否暂停请求
    output reg stall_req
);

    wire rs1_conflict_ex = alu_reg_we && (alu_reg_waddr != 0) && (alu_reg_waddr == id_rs1);
    wire rs2_conflict_ex = alu_reg_we && (alu_reg_waddr != 0) && (alu_reg_waddr == id_rs2);
    wire rs1_conflict_mem = mem_reg_we && (mem_reg_waddr != 0) && (mem_reg_waddr == id_rs1);
    wire rs2_conflict_mem = mem_reg_we && (mem_reg_waddr != 0) && (mem_reg_waddr == id_rs2);

    always @(*) begin
        if (!rst) begin
            stall_req = 1'b0;
        end else if (rs1_conflict_ex || rs2_conflict_ex || rs1_conflict_mem || rs2_conflict_mem) begin
            stall_req = 1'b1;
        end else begin
            stall_req = 1'b0;
        end
    end

endmodule
