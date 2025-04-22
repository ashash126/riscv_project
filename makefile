# 文件名：Makefile

# 工具定义
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# 文件列表
SRC = \
    gen_dff.v \
    tb_tinyriscv.v \
    tinyriscv_temp.v \
    pc_reg.v \
    instruction_mem.v \
    data_mem.v \
    if_id.v \
    id_temp.v \
    id_ex_temp.v \
    ex_temp.v \
    jump_ctrl.v \
    regs_temp.v \
    defines.v

# 输出文件
OUT = tb.out
WAVE = waveform.vcd

# 默认目标
all: sim wave

# 编译
sim:
	@echo "========== Compiling =========="
	$(IVERILOG) -o $(OUT) $(SRC)
	@echo "✅ Compilation done."
	@echo "========== Running simulation =========="
	$(VVP) $(OUT)

# 打开波形（兼容 PowerShell / CMD / Bash）
wave:
	@if exist $(WAVE) ( \
		echo ========== Opening waveform ========== && \
		$(GTKWAVE) $(WAVE) \
	) else ( \
		echo ❌ $(WAVE) not found. \
	)

# 清理临时文件
clean:
	del /Q $(OUT) $(WAVE) 2>nul || rm -f $(OUT) $(WAVE)

.PHONY: all sim wave clean
