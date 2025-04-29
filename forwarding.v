`include "defines.v"

//注释写得有问题
module reg_forward_unit(
    input wire rst,

    // ID阶段源寄存器地址
    input wire [`RegAddrBus] id_rs1,
    input wire [`RegAddrBus] id_rs2,

    // EX阶段目的寄存器地址+写使能+写数据
    input wire [`RegAddrBus] ex_rd_i,
    input wire ex_reg_we_i,
    input wire [`RegBus] ex_reg_wdata_i,

    // MEM阶段目的寄存器地址+写使能+写数据
    input wire [`RegAddrBus] mem_rd_i,
    input wire mem_reg_we_i,
    input wire [`RegBus] mem_reg_wdata_i,

    // ID阶段原始的reg1/2读数据
    input wire [`RegBus] reg1_rdata_i,
    input wire [`RegBus] reg2_rdata_i,

    input wire [`RegAddrBus] lr_rd_i,
    input wire lr_reg_we_i,
    input wire [`RegBus] lr_reg_wdata_i,

    input wire choice_flag, // 选择是否使用lr的值

    // ALU原始的op1/op2
    input wire [`RegBus] op1_i,
    input wire [`RegBus] op2_i,

    // 是否是store指令（EX阶段）
    input wire alu_is_store,

    // 是否是jalr指令（EX阶段）
    input wire alu_is_jalr,
    
    input wire [31:0]op1_jump_i,

    // 输出mux之后的reg1、reg2读数据
    output reg [`RegBus] reg1_rdata_o,
    output reg [`RegBus] reg2_rdata_o,

    output reg [`RegBus] op1_jump_o,

    // 输出mux之后的op1、op2
    output reg [`RegBus] op1_o,
    output reg [`RegBus] op2_o
);

    reg [`RegBus] ex_reg_wdata;
    reg [`RegBus] mem_reg_wdata;
    reg [`RegAddrBus] ex_rd;
    reg [`RegAddrBus] mem_rd;
    reg ex_reg_we;
    reg mem_reg_we;

    // 选择是否使用lr的值
    always @(*) begin
        if (choice_flag) begin
            ex_reg_wdata = mem_reg_wdata_i;
            mem_reg_wdata = lr_reg_wdata_i;
            ex_rd = mem_rd_i;
            mem_rd = lr_rd_i;
            ex_reg_we = mem_reg_we_i;
            mem_reg_we = lr_reg_we_i;
        end else begin
            ex_reg_wdata = ex_reg_wdata_i;
            mem_reg_wdata = mem_reg_wdata_i;
            ex_rd = ex_rd_i;
            mem_rd = mem_rd_i;
            ex_reg_we = ex_reg_we_i;
            mem_reg_we = mem_reg_we_i;
        end
    end


    always @(*) begin
        if (!rst) begin
            reg1_rdata_o = 0;
            reg2_rdata_o = 0;
            op1_o = 0;
            op2_o = 0;
            op1_jump_o = 0;
        end else begin
            // reg1_rdata_o
            if (ex_reg_we && (ex_rd != 0) && (ex_rd == id_rs1)) begin
                reg1_rdata_o = ex_reg_wdata;
            end else if (mem_reg_we && (mem_rd != 0) && (mem_rd == id_rs1)) begin
                reg1_rdata_o = mem_reg_wdata;
            end else begin
                reg1_rdata_o = reg1_rdata_i;
            end

            // reg2_rdata_o
            if (ex_reg_we && (ex_rd != 0) && (ex_rd == id_rs2)) begin
                reg2_rdata_o = ex_reg_wdata;
            end else if (mem_reg_we && (mem_rd != 0) && (mem_rd == id_rs2)) begin
                reg2_rdata_o = mem_reg_wdata;
            end else begin
                reg2_rdata_o = reg2_rdata_i;
            end

            // op1_o
            if (ex_reg_we && (ex_rd != 0) && (ex_rd == id_rs1)) begin
                op1_o = ex_reg_wdata;
            end else if (mem_reg_we && (mem_rd != 0) && (mem_rd == id_rs1)) begin
                op1_o = mem_reg_wdata;
            end else begin
                op1_o = op1_i;
            end

            // op2_o
            if (alu_is_store) begin
                op2_o = op2_i; // store指令op2不forward
            end else if (ex_reg_we && (ex_rd != 0) && (ex_rd == id_rs2)) begin
                op2_o = ex_reg_wdata;
            end else if (mem_reg_we && (mem_rd != 0) && (mem_rd == id_rs2)) begin
                op2_o = mem_reg_wdata;
            end else begin
                op2_o = op2_i;
            end

            // op1_jump_o
            if(alu_is_jalr) begin
                if (ex_reg_we && (ex_rd != 0) && (ex_rd == id_rs1)) begin
                    op1_jump_o = ex_reg_wdata;
                end else if (mem_reg_we && (mem_rd != 0) && (mem_rd == id_rs1)) begin
                    op1_jump_o = mem_reg_wdata;
                end else begin
                    op1_jump_o = op1_jump_i;
                end
            end  else begin
                op1_jump_o = op1_jump_i;
            end

        end
    end

endmodule
