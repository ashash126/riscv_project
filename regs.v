
`include "defines.v"

// 通用寄存器模块
module regs(

    input wire clk,
    input wire rst,

    // from ex
    input wire we_i,                      // 写寄存器标志
    input wire[`RegAddrBus] waddr_i,      // 写寄存器地址
    input wire[`RegBus] wdata_i,          // 写寄存器数据

    // from jtag
    //input wire jtag_we_i,                 // 写寄存器标志
    //input wire[`RegAddrBus] jtag_addr_i,  // 读、写寄存器地址
    //input wire[`RegBus] jtag_data_i,      // 写寄存器数据

    // from id
    input wire[`RegAddrBus] raddr1_i,     // 读寄存器1地址

    // to id
    output reg[`RegBus] rdata1_o,         // 读寄存器1数据

    // from id
    input wire[`RegAddrBus] raddr2_i,     // 读寄存器2地址

    // to id
    output reg[`RegBus] rdata2_o         // 读寄存器2数据

    // to jtag
    //output reg[`RegBus] jtag_data_o       // 读寄存器数据

    );

    reg[`RegBus] regs[0:`RegNum - 1];

    // 写寄存器
    always @ (posedge clk) begin
        if (rst == `RstDisable) begin
            // 优先ex模块写操作
            if ((we_i == `WriteEnable) && (waddr_i != `ZeroReg)) begin
                regs[waddr_i] <= wdata_i;
            end //else if ((jtag_we_i == `WriteEnable) && (jtag_addr_i != `ZeroReg)) begin
                //regs[jtag_addr_i] <= jtag_data_i;
            //end
        end
    end

    // 读寄存器1
    always @ (*) begin
        if (raddr1_i == `ZeroReg) begin
            rdata1_o = `ZeroWord;
        // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end else if (raddr1_i == waddr_i && we_i == `WriteEnable) begin
            rdata1_o = wdata_i;
        end else begin
            rdata1_o = regs[raddr1_i];
        end
    end

    // 读寄存器2
    always @ (*) begin
        if (raddr2_i == `ZeroReg) begin
            rdata2_o = `ZeroWord;
        // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end else if (raddr2_i == waddr_i && we_i == `WriteEnable) begin
            rdata2_o = wdata_i;
        end else begin
            rdata2_o = regs[raddr2_i];
        end
    end

    // jtag读寄存器
    //always @ (*) begin
    //    if (jtag_addr_i == `ZeroReg) begin
    //        jtag_data_o = `ZeroWord;
    //    end else begin
    //        jtag_data_o = regs[jtag_addr_i];
    //    end
    //end


wire [31:0] reg_0  = regs[0];
wire [31:0] reg_1  = regs[1];
wire [31:0] reg_2  = regs[2];
wire [31:0] reg_3  = regs[3];
wire [31:0] reg_4  = regs[4];
wire [31:0] reg_5  = regs[5];
wire [31:0] reg_6  = regs[6];
wire [31:0] reg_7  = regs[7];
wire [31:0] reg_8  = regs[8];
wire [31:0] reg_9  = regs[9];
wire [31:0] reg_10 = regs[10];
wire [31:0] reg_11 = regs[11];
wire [31:0] reg_12 = regs[12];
wire [31:0] reg_13 = regs[13];
wire [31:0] reg_14 = regs[14];
wire [31:0] reg_15 = regs[15];
wire [31:0] reg_16 = regs[16];
wire [31:0] reg_17 = regs[17];
wire [31:0] reg_18 = regs[18];
wire [31:0] reg_19 = regs[19];
wire [31:0] reg_20 = regs[20];
wire [31:0] reg_21 = regs[21];
wire [31:0] reg_22 = regs[22];
wire [31:0] reg_23 = regs[23];
wire [31:0] reg_24 = regs[24];
wire [31:0] reg_25 = regs[25];
wire [31:0] reg_26 = regs[26];
wire [31:0] reg_27 = regs[27];
wire [31:0] reg_28 = regs[28];
wire [31:0] reg_29 = regs[29];
wire [31:0] reg_30 = regs[30];
wire [31:0] reg_31 = regs[31];



endmodule
