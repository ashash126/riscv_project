import os
import subprocess
import re

# 读取寄存器值文件并检查是否满足条件
def check_registers(file_path, data_file, output_file):
    try:
        with open(file_path, 'r') as f:
            lines = f.readlines()

        reg_26_previous = None
        reg_27_previous = None
        reg_26_time = None
        pass_flag = False  # Track pass or fail status

        # 遍历每一行，提取 reg_26 和 reg_27 的值
        for line in lines:
            # 提取 reg_26 和 reg_27 的值
            if "reg_26" in line and "reg_27" in line:
                time, reg_26_value, reg_27_value = line.split('|')
                reg_26_value = reg_26_value.split(':')[1].strip()
                reg_27_value = reg_27_value.split(':')[1].strip()

                # 检查条件：reg_26 从 0 变到 1 后，下一周期 reg_27 从 0 变到 1
                if reg_26_previous == "00000000" and reg_26_value == "00000001":
                    reg_26_time = time.strip()
                    reg_26_previous = reg_26_value
                    reg_27_previous = reg_27_value
                elif reg_26_time and reg_26_value == "00000001" and reg_27_previous == "00000000" and reg_27_value == "00000001":
                    pass_flag = True  # Set flag to True when the condition is met
                    reg_26_time = None  # Reset after successful match
                else:
                    reg_26_previous = reg_26_value
                    reg_27_previous = reg_27_value

        # After checking all lines, print pass or fail for the corresponding data_file
        if pass_flag:
            output_file.write(f"{data_file} pass\n")
        else:
            output_file.write(f"{data_file} fail\n")

    except Exception as e:
        output_file.write(f"Error reading file {file_path}: {e}\n")

# 执行makefile进行仿真
def run_simulation(output_file):
    try:
        subprocess.run(["make"], check=True)
    except subprocess.CalledProcessError as e:
        output_file.write(f"Error during simulation: {e}\n")

# 读取文件并保存到目标文件
def copy_file(src, dst, output_file):
    try:
        with open(src, 'r') as f_src:
            content = f_src.read()
        with open(dst, 'w') as f_dst:
            f_dst.write(content)
        output_file.write(f"File {src} successfully copied to {dst}\n")
    except Exception as e:
        output_file.write(f"Error copying file {src} to {dst}: {e}\n")

# 遍历文件夹中的所有文件并进行处理
def process_files(folder_path, output_file):
    # 获取所有符合指令存储文件的文件
    instruction_files = sorted([f for f in os.listdir(folder_path) if re.match(r'rv32ui-p-\S+_yty\.txt', f)])
    # 获取所有符合数据存储文件的文件
    data_files = sorted([f for f in os.listdir(folder_path) if re.match(r'rv32ui-p-\S+\.txt$', f) and not re.match(r'rv32ui-p-\S+_yty\.txt', f)])

    # 确保两个文件夹中的文件数量一致
    if len(instruction_files) != len(data_files):
        output_file.write("Mismatch between instruction files and data files!\n")
        return

    # 依次处理每对文件
    for inst_file, data_file in zip(instruction_files, data_files):
        output_file.write(f"Processing {inst_file} and {data_file}...\n")

        # 将文件复制到目标文件
        copy_file(os.path.join(folder_path, inst_file), 'inst_mem.txt', output_file)
        copy_file(os.path.join(folder_path, data_file), 'data_mem.txt', output_file)

        # 运行仿真
        run_simulation(output_file)

        # 检查寄存器值文件中的寄存器状态并输出结果
        check_registers(os.path.join(os.path.dirname(__file__), 'reg_values.txt'), data_file, output_file)  # Pass the data_file

# 读取并打印带有 pass/fail 的行
def print_pass_fail_lines(output_file_path):
    try:
        with open(output_file_path, 'r') as file:
            lines = file.readlines()

        # 遍历每一行，打印包含 pass 或 fail 的行
        for line in lines:
            if 'pass' in line or 'fail' in line:
                print(line.strip())  # Remove any leading/trailing spaces or newline characters

    except Exception as e:
        print(f"Error reading {output_file_path}: {e}")

# 主函数
def main():
    # 设置包含文件的文件夹路径
    folder_path = os.path.join(os.path.dirname(__file__), 'generated')  # 当前目录下的generated文件夹

    # 打开输出文件并开始处理文件夹中的所有文件
    output_file_path = 'output.txt'
    with open(output_file_path, 'w') as output_file:
        process_files(folder_path, output_file)

    # 在处理完所有文件后，读取并打印输出文件中带有 pass 或 fail 的行
    print_pass_fail_lines(output_file_path)

if __name__ == '__main__':
    main()

