// load  有问题 314行左右 需要读出
// store  有问题 要读出之后接着写

// 解决方案 alu只执行I R 指令
`include "defines.v"

// 执行模块
module alu(

    input wire rst,

    // from id
    input wire[`InstBus] inst_i,            // 指令内容
    input wire[`InstAddrBus] inst_addr_i,   // 指令地址
    input wire reg_we_i,                    // 是否写通用寄存器
    input wire[`RegAddrBus] reg_waddr_i,    // 写通用寄存器地址
    input wire[`RegBus] reg1_rdata_i,       // 通用寄存器1输入数据
    input wire[`RegBus] reg2_rdata_i,       // 通用寄存器2输入数据


    input wire[`MemAddrBus] op1_i,
    input wire[`MemAddrBus] op2_i,
    input wire[`MemAddrBus] op1_jump_i,
    input wire[`MemAddrBus] op2_jump_i,

    // to mem (实际上并不调用这一部分)
    output reg[`MemBus] mem_wdata_o,        // 写内存数据
    output reg[`MemAddrBus] mem_raddr_o,    // 读内存地址
    output reg[`MemAddrBus] mem_waddr_o,    // 写内存地址
    output wire mem_we_o,                   // 是否要写内存
    output wire mem_req_o,                  // 请求访问内存标志

    // to regs
    output wire[`RegBus] reg_wdata_o,       // 写寄存器数据
    output wire reg_we_o,                   // 是否要写通用寄存器
    output wire[`RegAddrBus] reg_waddr_o,   // 写通用寄存器地址

    //to ex_mem
    output wire[`InstBus] inst_o,            // 指令内容
    output wire[`InstAddrBus] inst_addr_o,   // 指令地址
    output wire [`InstAddrBus] op1_add_op2_res, // 计算结果
    output wire [1:0] mem_raddr_index, // 读内存地址索引
    output wire [1:0] mem_waddr_index, // 写内存地址索引
    output wire[`RegBus] reg2_rdata_o, // 读寄存器2数据

    output reg alu_is_load, // 是否是load指令
    output reg alu_is_store, // 是否是store指令
    output reg alu_is_jalr, // 是否是jalr指令

    output reg jump_flag,               // 跳转标志
    output reg [`InstAddrBus]jump_addr      // 跳转地址
    );

    assign reg2_rdata_o = reg2_rdata_i; // 直接传递寄存器2数据

    wire[31:0] sr_shift;
    wire[31:0] sri_shift;
    wire[31:0] sr_shift_mask;
    wire[31:0] sri_shift_mask;

    wire[31:0] op1_jump_add_op2_jump_res;
    wire[31:0] reg1_data_invert;
    wire[31:0] reg2_data_invert;
    wire op1_ge_op2_signed;
    wire op1_ge_op2_unsigned;
    wire op1_eq_op2;

    wire[6:0] opcode;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[4:0] rd;
    wire[4:0] uimm;
    reg[`RegBus] reg_wdata;
    reg reg_we;
    reg[`RegAddrBus] reg_waddr;

    reg mem_we;
    reg mem_req;

    assign inst_o = inst_i; // 直接传递指令
    assign inst_addr_o = inst_addr_i; // 直接传递指令地址

    assign opcode = inst_i[6:0];
    assign funct3 = inst_i[14:12];
    assign funct7 = inst_i[31:25];
    assign rd = inst_i[11:7];
    assign uimm = inst_i[19:15];

    assign sr_shift = reg1_rdata_i >> reg2_rdata_i[4:0];
    assign sri_shift = reg1_rdata_i >> inst_i[24:20];
    assign sr_shift_mask = 32'hffffffff >> reg2_rdata_i[4:0];
    assign sri_shift_mask = 32'hffffffff >> inst_i[24:20];

    assign op1_add_op2_res = op1_i + op2_i;
    assign op1_jump_add_op2_jump_res = op1_jump_i + op2_jump_i;

    assign reg1_data_invert = ~reg1_rdata_i + 1;
    assign reg2_data_invert = ~reg2_rdata_i + 1;

    // 有符号数比较
    assign op1_ge_op2_signed = $signed(op1_i) >= $signed(op2_i);
    // 无符号数比较
    assign op1_ge_op2_unsigned = op1_i >= op2_i;
    assign op1_eq_op2 = (op1_i == op2_i);


    assign reg_wdata_o = reg_wdata ;
    // 响应中断时不写通用寄存器
    assign reg_we_o = reg_we ;
    assign reg_waddr_o = reg_waddr ;

    // 响应中断时不写内存
    assign mem_we_o =  mem_we;

    // 响应中断时不向总线请求访问内存
    assign mem_req_o =  mem_req;

    assign mem_raddr_index = (reg1_rdata_i + {{20{inst_i[31]}}, inst_i[31:20]}) & 2'b11;
    assign mem_waddr_index = (reg1_rdata_i + {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]}) & 2'b11;
        always @ (*) begin
        jump_flag = `JumpDisable;
        jump_addr = `ZeroWord;
        case (opcode)
            `INST_TYPE_B: begin
                case (funct3)
                    `INST_BEQ: begin
                        jump_flag = op1_eq_op2 & `JumpEnable;
                        jump_addr = {32{op1_eq_op2}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BNE: begin
                        jump_flag = ~op1_eq_op2 & `JumpEnable;
                        jump_addr = {32{~op1_eq_op2}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BLT: begin
                        jump_flag = (~op1_ge_op2_signed) & `JumpEnable;
                        jump_addr = {32{(~op1_ge_op2_signed)}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BGE: begin
                        jump_flag = op1_ge_op2_signed & `JumpEnable;
                        jump_addr = {32{(op1_ge_op2_signed)}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BLTU: begin
                        jump_flag = (~op1_ge_op2_unsigned) & `JumpEnable;
                        jump_addr = {32{(~op1_ge_op2_unsigned)}} & op1_jump_add_op2_jump_res;
                    end
                    `INST_BGEU: begin
                        jump_flag = op1_ge_op2_unsigned & `JumpEnable;
                        jump_addr = {32{(op1_ge_op2_unsigned)}} & op1_jump_add_op2_jump_res;
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        jump_addr = `ZeroWord;
                    end
                endcase
            end
            `INST_JAL, `INST_JALR: begin
                jump_flag = `JumpEnable;
                jump_addr = op1_jump_add_op2_jump_res;
            end
            default: begin
                jump_flag = `JumpDisable;
                jump_addr = `ZeroWord;
            end
        endcase
    end

// ex阶段是否是load指令
always @(*) begin
    case (opcode)
        `INST_TYPE_L: begin  // load指令类型
            case (funct3)
                `INST_LB, `INST_LH, `INST_LW, `INST_LBU, `INST_LHU: begin
                    alu_is_load = 1'b1;  // 这些是load指令
                end
                default: begin
                    alu_is_load = 1'b0;
                end
            endcase
        end

        default: begin
            alu_is_load = 1'b0;  // 其他情况默认不是
        end
    endcase
end

// ex阶段是否是store指令
always @(*) begin
    case (opcode)
        `INST_TYPE_S: begin  // load指令类型
            case (funct3)
                `INST_SB, `INST_SH, `INST_SW: begin
                    alu_is_store = 1'b1;  // 这些是load指令
                end
                default: begin
                    alu_is_store = 1'b0;
                end
            endcase
        end

        default: begin
            alu_is_store = 1'b0;  // 其他情况默认不是
        end
    endcase
end


// ex阶段是否是jalr指令
always @(*) begin
    case (opcode)
        `INST_JALR: begin  // jalr指令类型
            alu_is_jalr = 1'b1;  // 这些是jalr指令
        end
        default: begin
            alu_is_jalr = 1'b0;  // 其他情况默认不是
        end
    endcase
end    

    // 执行ALU功能
    always @ (*) begin
        reg_we = reg_we_i;
        reg_waddr = reg_waddr_i;
        mem_req = `RIB_NREQ;

        case (opcode)
            `INST_TYPE_I: begin
                case (funct3)
                    `INST_ADDI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_add_op2_res;
                    end
                    `INST_SLTI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = {32{(~op1_ge_op2_signed)}} & 32'h1;
                    end
                    `INST_SLTIU: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = {32{(~op1_ge_op2_unsigned)}} & 32'h1;
                    end
                    `INST_XORI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i ^ op2_i;
                    end
                    `INST_ORI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i | op2_i;
                    end
                    `INST_ANDI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i & op2_i;
                    end
                    `INST_SLLI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = reg1_rdata_i << inst_i[24:20];
                    end
                    `INST_SRI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        if (inst_i[30] == 1'b1) begin
                            reg_wdata = (sri_shift & sri_shift_mask) | ({32{reg1_rdata_i[31]}} & (~sri_shift_mask));
                        end else begin
                            reg_wdata = reg1_rdata_i >> inst_i[24:20];
                        end
                    end
                    default: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            `INST_TYPE_R_M: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3)
                        `INST_ADD_SUB: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            if (inst_i[30] == 1'b0) begin
                                reg_wdata = op1_add_op2_res;
                            end else begin
                                reg_wdata = op1_i - op2_i;
                            end
                        end
                        `INST_SLL: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i << op2_i[4:0];
                        end
                        `INST_SLT: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = {32{(~op1_ge_op2_signed)}} & 32'h1;
                        end
                        `INST_SLTU: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = {32{(~op1_ge_op2_unsigned)}} & 32'h1;
                        end
                        `INST_XOR: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i ^ op2_i;
                        end
                        `INST_SR: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            if (inst_i[30] == 1'b1) begin
                                reg_wdata = (sr_shift & sr_shift_mask) | ({32{reg1_rdata_i[31]}} & (~sr_shift_mask));
                            end else begin
                                reg_wdata = reg1_rdata_i >> reg2_rdata_i[4:0];
                            end
                        end
                        `INST_OR: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i | op2_i;
                        end
                        `INST_AND: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i & op2_i;
                        end
                        default: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = `ZeroWord;
                        end
                    endcase
                end else if (funct7 == 7'b0000001) begin
                    case (funct3)
                        default: begin
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = `ZeroWord;
                        end
                    endcase
                end else begin
                    mem_wdata_o = `ZeroWord;
                    mem_raddr_o = `ZeroWord;
                    mem_waddr_o = `ZeroWord;
                    mem_we = `WriteDisable;
                    reg_wdata = `ZeroWord;
                end
            end
            `INST_JAL: begin
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = op1_add_op2_res;
            end
            `INST_JALR: begin
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = op1_add_op2_res - 32'h8; //这是什么玩意？
            end

            `INST_LUI, `INST_AUIPC: begin
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = op1_add_op2_res;
            end
            `INST_NOP_OP: begin
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = `ZeroWord;
            end
            default: begin
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = `ZeroWord;
            end
        endcase
    end

endmodule
