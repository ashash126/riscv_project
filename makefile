# 文件名：Makefile

# 工具定义
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# 文件列表
SRC = \
    gen_dff.v \
    tb_tinyriscv.v \
    tinyriscv.v \
    pc_reg.v \
    instruction_mem.v \
    data_mem.v \
    if_id.v \
    id.v \
    id_ex.v \
    jump_ctrl.v \
    regs.v \
    ex_mem.v \
    alu.v \
    mem_ctrl.v \
    mem_wb.v \
    hazard_detect_unit.v \
    stall_control.v \
    forwarding.v \
    last_regs.v \
    choice_flag_ctrl.v \
    defines.v

# 输出文件
OUT = tb.out
WAVE = waveform.vcd

# 默认目标
all: sim 

# 编译
sim:
	@echo "========== Compiling =========="
	$(IVERILOG) -o $(OUT) $(SRC)
	@echo "✅ Compilation done."
	@echo "========== Running simulation =========="
	$(VVP) $(OUT)

# # 打开波形（兼容 PowerShell / CMD / Bash）
# wave:
# 	@if exist $(WAVE) ( \
# 		echo ========== Opening waveform ========== && \
# 		$(GTKWAVE) $(WAVE) \
# 	) else ( \
# 		echo ❌ $(WAVE) not found. \
# 	)

# 清理临时文件
clean:
	del /Q $(OUT) $(WAVE) 2>nul || rm -f $(OUT) $(WAVE)

.PHONY: all sim wave clean
