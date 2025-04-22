woshiyangyangyang

```markdown
# RISC-V Processor Project

这是一个基于 RISC-V 架构的处理器设计项目，使用 Verilog HDL 实现。项目包括处理器的各个模块、测试平台以及相关的内存和指令文件，适合用于学习和验证基本的五级流水线处理器实现。

## 📁 项目结构

<pre>
├── <b>data_mem.txt</b>          数据内存初始化文件  
├── <b>data_mem.v</b>            数据内存模块  
├── <b>defines.v</b>             宏定义文件  
├── <b>ex_temp.v</b>             执行阶段模块  
├── <b>gen_dff.v</b>             通用 D 触发器模块  
├── <b>id_ex_temp.v</b>          ID/EX 阶段寄存器模块  
├── <b>id_temp.v</b>             指令译码模块  
├── <b>if_id.v</b>               IF/ID 阶段寄存器模块  
├── <b>inst_mem.txt</b>          指令内存初始化文件  
├── <b>inst_v1.txt</b>           指令集文件  
├── <b>instruction_mem.v</b>     指令内存模块  
├── <b>jump_ctrl.v</b>           跳转控制模块  
├── <b>makefile</b>              编译和仿真脚本  
├── <b>pc_reg.v</b>              程序计数器模块  
├── <b>regs_temp.v</b>           寄存器堆模块  
├── <b>tb.out</b>                仿真输出文件  
├── <b>tb_tinyriscv.v</b>        测试平台  
├── <b>tinyriscv_temp.v</b>      顶层模块  
└── <b>waveform.vcd</b>          仿真波形文件  
</pre>

## 🚀 快速开始

### ✅ 环境要求

- Verilog HDL 仿真工具（如 Icarus Verilog）
- 波形查看工具（如 GTKWave）

### 🧪 编译与仿真

```bash
make
```

仿真完成后，使用以下命令查看波形：

```bash
gtkwave waveform.vcd
```

## 🤝 贡献

欢迎提出 issue 或提交 pull request 改进本项目！你也可以 fork 并开发属于自己的 RISC-V 处理器。

## 📄 许可证

本项目使用 MIT 许可证，详见 LICENSE 文件（如添加）。
```



