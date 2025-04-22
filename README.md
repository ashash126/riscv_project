RISC-V Processor Project​
GitHub
+7
GitHub
+7
GitHub
+7
这是一个基于 RISC-V 架构的处理器设计项目，​使用 Verilog HDL 实现。​项目包括处理器的各个模块、测试平台以及相关的内存和指令文件。​
GitHub
+3
GitHub
+3
知乎
+3
GitHub
+7
知乎
+7
GitHub
+7

项目结构
bash
复制
编辑
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
快速开始
环境要求
Verilog HDL 仿真工具（如 Icarus Verilog）

波形查看工具（如 GTKWave）​

编译与仿真
确保所有源文件和测试文件位于同一目录下。

使用以下命令进行编译和仿真：​
GitHub

bash
复制
编辑
make
仿真完成后，使用波形查看工具打开 waveform.vcd 文件以查看仿真波形。​
GitHub

贡献
欢迎对本项目提出建议或贡献代码。​请通过提交 issue 或 pull request 的方式参与。​

许可证
本项目采用 MIT 许可证。
