
`include "defines.v"

// 控制模块
// 发出跳转、暂停流水线信号
module ctrl(

    input wire rst,

    // from id
    input wire jump_flag_i,
    input wire[`InstAddrBus] jump_addr_i,


    // to pc_reg
    output reg jump_flag_o,
    output reg[`InstAddrBus] jump_addr_o,

    // to if_id
    output reg rst_if_id
    );


    always @ (*) begin
        jump_addr_o = jump_addr_i;
        jump_flag_o = jump_flag_i;
        rst_if_id = jump_flag_i;

    end

endmodule
