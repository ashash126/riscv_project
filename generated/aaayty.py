import re
import os

# 设置文件夹路径
folder_path = 'F:\generated'  # 替换为文件夹路径
output_folder_path = 'F:\generated'  # 替换为输出文件夹路径

# 定义一个正则表达式来匹配8位的十六进制指令
hex_pattern = r'\b[0-9a-fA-F]{8}\b(?!\s*<)'

# 遍历文件夹中的所有 .dump 文件
for file_name in os.listdir(folder_path):
    if file_name.endswith('.dump'):  # 修改为处理 .dump 文件
        file_path = os.path.join(folder_path, file_name)
        output_file_path = os.path.join(output_folder_path, file_name.replace('.dump', '_yty.txt'))

        # 读取文件内容并提取十六进制指令
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                file_contents = file.readlines()
        except UnicodeDecodeError:
            print(f"无法读取文件 {file_path}，尝试其他编码")
            continue  # Skip this file if it can't be decoded with utf-8

        hex_instructions = []
        for line in file_contents:
            matches = re.findall(hex_pattern, line.strip())
            hex_instructions.extend(matches)

        # 将提取到的十六进制指令写入新文件
        with open(output_file_path, 'w', encoding='utf-8') as output_file:
            output_file.write('\n'.join(hex_instructions))

        print(f"提取的8位十六进制指令已保存到: {output_file_path}")
