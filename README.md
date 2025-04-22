
```markdown
# RISC-V Processor Project

这是一个基于 RISC-V 架构的处理器设计项目，使用 Verilog HDL 实现。项目包括处理器的各个模块、测试平台以及相关的内存和指令文件。

## 📁 项目结构

```
├── data_mem.txt          # 数据内存初始化文件
├── data_mem.v            # 数据内存模块
├── defines.v             # 宏定义文件
├── ex_temp.v             # 执行阶段模块
├── gen_dff.v             # 通用 D 触发器模块
├── id_ex_temp.v          # ID/EX 阶段寄存器模块
├── id_temp.v             # 指令译码模块
├── if_id.v               # IF/ID 阶段寄存器模块
├── inst_mem.txt          # 指令内存初始化文件
├── inst_v1.txt           # 指令集文件
├── instruction_mem.v     # 指令内存模块
├── jump_ctrl.v           # 跳转控制模块
├── makefile              # 编译和仿真脚本
├── pc_reg.v              # 程序计数器模块
├── regs_temp.v           # 寄存器堆模块
├── tb.out                # 仿真输出文件
├── tb_tinyriscv.v        # 测试平台
├── tinyriscv_temp.v      # 顶层模块
└── waveform.vcd          # 仿真波形文件
```

## 🚀 快速开始

### 环境要求

- Verilog HDL 仿真工具（如 Icarus Verilog）
- 波形查看工具（如 GTKWave）

### 编译与仿真

```bash
make
```

仿真完成后，使用 `GTKWave waveform.vcd` 查看仿真波形。

## 🤝 贡献

欢迎提出 issue 或提交 pull request 改进本项目！

## 📄 许可证

本项目使用 MIT 许可证。
```
