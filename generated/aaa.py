import re

# 读取输入文件内容
file_path = 'F:\generated\\rv32ui-p-bge.dump'  # 您的输入文件路径
output_file_path = 'F:\generated\\rv32ui-p-bge_yty.txt'  # 输出文件路径

# 定义一个正则表达式来匹配8位的十六进制指令
# 只匹配不含其他字符（如 <test_2> 等标签）的8位十六进制指令
hex_pattern = r'\b[0-9a-fA-F]{8}\b(?!\s*<)'

# 读取文件内容并提取十六进制指令
with open(file_path, 'r') as file:
    file_contents = file.readlines()

# 提取所有匹配的8位十六进制指令
hex_instructions = []
for line in file_contents:
    matches = re.findall(hex_pattern, line.strip())
    hex_instructions.extend(matches)

# 将提取到的十六进制指令写入新文件
with open(output_file_path, 'w') as output_file:
    output_file.write('\n'.join(hex_instructions))

print(f"提取的8位十六进制指令已保存到: {output_file_path}")
