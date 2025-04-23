`include "defines.v"

// tinyriscv处理器核顶层模块
module tinyriscv(
    input wire clk,
    input wire rst
);

    // instruction_mem 输出
    wire [31:0] inst_mem_inst_o;
    
    // data_mem 输出
    wire [31:0] data_mem_rdata_o;

    // pc_reg模块输出信号
	wire[`InstAddrBus] pc_pc_o;

    // if_id模块输出信号
	wire[`InstBus] if_inst_o;
    wire[`InstAddrBus] if_inst_addr_o;

    // id模块输出信号
    wire[`RegAddrBus] id_reg1_raddr_o;
    wire[`RegAddrBus] id_reg2_raddr_o;
    wire[`InstBus] id_inst_o;
    wire[`InstAddrBus] id_inst_addr_o;
    wire[`RegBus] id_reg1_rdata_o;
    wire[`RegBus] id_reg2_rdata_o;
    wire id_reg_we_o;
    wire[`RegAddrBus] id_reg_waddr_o;
    wire[`MemAddrBus] id_op1_o;
    wire[`MemAddrBus] id_op2_o;
    wire[`MemAddrBus] id_op1_jump_o;
    wire[`MemAddrBus] id_op2_jump_o;
    wire jump_flag;
    wire[`InstAddrBus] jump_addr;

    // id_ex模块输出信号
    wire[`InstBus] ie_inst_o;
    wire[`InstAddrBus] ie_inst_addr_o;
    wire ie_reg_we_o;
    wire[`RegAddrBus] ie_reg_waddr_o;
    wire[`RegBus] ie_reg1_rdata_o;
    wire[`RegBus] ie_reg2_rdata_o;
    wire[`MemAddrBus] ie_op1_o;
    wire[`MemAddrBus] ie_op2_o;
    wire[`MemAddrBus] ie_op1_jump_o;
    wire[`MemAddrBus] ie_op2_jump_o;

    // alu模块输出信号
    wire[4:0] alu_reg_waddr_o;
    wire[31:0] alu_reg_wdata_o;
    wire alu_reg_we_o;
    wire[`InstAddrBus] alu_inst_addr_o;
    wire[`InstBus] alu_inst_o;
    wire[`MemAddrBus] alu_op1_add_op2_res_o;
    wire[1:0] alu_mem_raddr_index_o; 
    wire[1:0] alu_mem_waddr_index_o;
    wire[`RegBus] alu_reg2_rdata_o;

    // regs模块输出信号
    wire[`RegBus] regs_rdata1_o;
    wire[`RegBus] regs_rdata2_o;

    // jump_ctrl模块输出信号
    wire jump_flag_o;
    wire[`InstAddrBus] jump_addr_o;
    wire rst_if_id_o;

    // ex_mem模块输出信号
    wire[`InstBus] em_inst_o;
    wire[`InstAddrBus] em_inst_addr_o;
    wire[`RegBus] em_reg_wdata_o;
    wire em_reg_we_o;
    wire[`RegAddrBus] em_reg_waddr_o;
    wire[`InstAddrBus] em_op1_add_op2_res_o;
    wire[1:0] em_mem_raddr_index_o;
    wire[1:0] em_mem_waddr_index_o;
    wire[`RegBus] em_reg2_rdata_o;

    //mem_ctrl模块输出信号
    wire[`MemBus] mc_mem_wdata_o;
    wire[`MemAddrBus] mc_mem_raddr_o;
    wire[`MemAddrBus] mc_mem_waddr_o;
    wire mc_mem_we_o;
    wire mc_mem_req_o;
    wire mc_reg_we_o;
    wire[`RegAddrBus] mc_reg_waddr_o;
    wire[`RegBus] mc_reg_wdata_o;

    // mem_wb模块输出信号
    wire[`RegBus] wb_reg_wdata_o;
    wire wb_reg_we_o;   
    wire[`RegAddrBus] wb_reg_waddr_o;

    // pc_reg模块例化
    pc_reg u_pc_reg(
        .clk(clk),
        .rst(rst),
        .pc_o(pc_pc_o),
        .hold_flag_i(),
        .jump_flag_i(jump_flag_o),
        .jump_addr_i(jump_addr_o)
    );

    // instruction_mem 实例
    instruction_mem u_instruction_mem (
        .address_i(pc_pc_o),
        .instruction_o(inst_mem_inst_o)
    );

    // data_mem 实例
    data_mem u_data_mem (
        .clk(clk),
        .rst(rst),
        .mem_we_i(mc_mem_we_o),
        .mem_req_i(mc_mem_req_o),
        .mem_waddr_i(mc_mem_waddr_o),
        .mem_wdata_i(mc_mem_wdata_o),
        .mem_raddr_i(mc_mem_raddr_o),
        .mem_rdata_o(data_mem_rdata_o)
    );

    // ctrl模块例化
    ctrl u_ctrl(
        .rst(rst),
        .jump_flag_i(jump_flag),
        .jump_addr_i(jump_addr),
        .jump_flag_o(jump_flag_o),
        .jump_addr_o(jump_addr_o),
        .rst_if_id(rst_if_id_o)
    );

    // regs模块例化
    regs u_regs(
        .clk(clk),
        .rst(rst),
        .we_i(wb_reg_we_o),
        .waddr_i(wb_reg_waddr_o),
        .wdata_i(wb_reg_wdata_o),
        .raddr1_i(id_reg1_raddr_o),
        .rdata1_o(regs_rdata1_o),
        .raddr2_i(id_reg2_raddr_o),
        .rdata2_o(regs_rdata2_o)
    );

    // if_id模块例化
    if_id u_if_id(
        .clk(clk),
        .rst(rst),
        .inst_i(inst_mem_inst_o),
        .inst_addr_i(pc_pc_o),
        .rst_if_id_i(rst_if_id_o),
        .inst_o(if_inst_o),
        .inst_addr_o(if_inst_addr_o)
    );

    // id模块例化
    id u_id(
        .rst(rst),
        .inst_i(if_inst_o),
        .inst_addr_i(if_inst_addr_o),
        .reg1_rdata_i(regs_rdata1_o),
        .reg2_rdata_i(regs_rdata2_o),
        .reg1_raddr_o(id_reg1_raddr_o),
        .reg2_raddr_o(id_reg2_raddr_o),
        .inst_o(id_inst_o),
        .inst_addr_o(id_inst_addr_o),
        .reg1_rdata_o(id_reg1_rdata_o),
        .reg2_rdata_o(id_reg2_rdata_o),
        .reg_we_o(id_reg_we_o),
        .reg_waddr_o(id_reg_waddr_o),
        .op1_o(id_op1_o),
        .op2_o(id_op2_o),
        .op1_jump_o(id_op1_jump_o),
        .op2_jump_o(id_op2_jump_o),
        .jump_flag(jump_flag),
        .jump_addr(jump_addr)
    );

    // id_ex模块例化
    id_ex u_id_ex(
        .clk(clk),
        .rst(rst),
        .inst_i(id_inst_o),
        .inst_addr_i(id_inst_addr_o),
        .reg_we_i(id_reg_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        .reg1_rdata_i(id_reg1_rdata_o),
        .reg2_rdata_i(id_reg2_rdata_o),
        .hold_flag_i(),
        .inst_o(ie_inst_o),
        .inst_addr_o(ie_inst_addr_o),
        .reg_we_o(ie_reg_we_o),
        .reg_waddr_o(ie_reg_waddr_o),
        .reg1_rdata_o(ie_reg1_rdata_o),
        .reg2_rdata_o(ie_reg2_rdata_o),
        .op1_i(id_op1_o),
        .op2_i(id_op2_o),
        .op1_jump_i(id_op1_jump_o),
        .op2_jump_i(id_op2_jump_o),
        .op1_o(ie_op1_o),
        .op2_o(ie_op2_o),
        .op1_jump_o(ie_op1_jump_o),
        .op2_jump_o(ie_op2_jump_o)
    );

    // alu模块例化
    alu u_alu(
        .inst_i(ie_inst_o),
        .inst_addr_i(ie_inst_addr_o),
        .reg_we_i(ie_reg_we_o),
        .reg_waddr_i(ie_reg_waddr_o),
        .reg1_rdata_i(ie_reg1_rdata_o),
        .reg2_rdata_i(ie_reg2_rdata_o),
        .op1_i(ie_op1_o),
        .op2_i(ie_op2_o),
        .op1_jump_i(ie_op1_jump_o),
        .op2_jump_i(ie_op2_jump_o),
        .reg_waddr_o(alu_reg_waddr_o),
        .reg_wdata_o(alu_reg_wdata_o),
        .reg_we_o(alu_reg_we_o),
        .inst_addr_o(alu_inst_addr_o),
        .inst_o(alu_inst_o),
        .op1_add_op2_res(alu_op1_add_op2_res_o),
        .mem_raddr_index(alu_mem_raddr_index_o),
        .mem_waddr_index(alu_mem_waddr_index_o),
        .reg2_rdata_o(alu_reg2_rdata_o)
    );

    // ex_mem模块例化
    ex_mem u_ex_mem(
        .clk(clk),
        .rst(rst),
        .inst_i(alu_inst_o),
        .inst_addr_i(alu_inst_addr_o),
        .reg_wdata_i(alu_reg_wdata_o),
        .reg_we_i(alu_reg_we_o),
        .reg_waddr_i(alu_reg_waddr_o),
        .op1_add_op2_res_i(alu_op1_add_op2_res_o),
        .mem_raddr_index_i(alu_mem_raddr_index_o),
        .mem_waddr_index_i(alu_mem_waddr_index_o),
        .reg2_rdata_i(alu_reg2_rdata_o),
        .inst_o(em_inst_o),
        .inst_addr_o(em_inst_addr_o),
        .reg_wdata_o(em_reg_wdata_o),
        .reg_we_o(em_reg_we_o),
        .reg_waddr_o(em_reg_waddr_o),
        .op1_add_op2_res_o(em_op1_add_op2_res_o),
        .mem_raddr_index_o(em_mem_raddr_index_o),
        .mem_waddr_index_o(em_mem_waddr_index_o),
        .reg2_rdata_o(em_reg2_rdata_o)
    );

    // mem_ctrl模块例化
    mem_ctrl u_mem_ctrl(
        .rst(rst),
        .inst_i(em_inst_o),
        .inst_addr_i(em_inst_addr_o),
        .op1_add_op2_res(em_op1_add_op2_res_o),
        .mem_raddr_index(em_mem_raddr_index_o),
        .mem_waddr_index(em_mem_waddr_index_o),
        .reg_wdata_i(em_reg_wdata_o),
        .reg_we_i(em_reg_we_o),
        .reg_waddr_i(em_reg_waddr_o),
        .reg2_rdata_i(em_reg2_rdata_o),
        .mem_wdata_o(mc_mem_wdata_o),
        .mem_raddr_o(mc_mem_raddr_o),
        .mem_waddr_o(mc_mem_waddr_o),
        .mem_we_o(mc_mem_we_o),
        .mem_req_o(mc_mem_req_o),
        .reg_we_o(mc_reg_we_o),
        .reg_waddr_o(mc_reg_waddr_o),
        .reg_wdata_o(mc_reg_wdata_o)
    );

    // mem_wb模块例化
    mem_wb u_mem_wb(
        .clk(clk),
        .rst(rst),
        .reg_wdata_i(mc_reg_wdata_o),
        .reg_we_i(mc_reg_we_o),
        .reg_waddr_i(mc_reg_waddr_o),
        .reg_wdata_o(wb_reg_wdata_o),
        .reg_we_o(wb_reg_we_o),
        .reg_waddr_o(wb_reg_waddr_o)
    );

endmodule
