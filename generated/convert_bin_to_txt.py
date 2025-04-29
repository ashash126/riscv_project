import os

def bin_to_txt(infile, outfile):
    with open(infile, 'rb') as binfile:
        content = binfile.read()
    
    with open(outfile, 'w') as txtfile:
        for i in range(0, len(content), 4):
            chunk = content[i:i+4]
            # 补齐不足4字节的内容
            chunk += b'\x00' * (4 - len(chunk))
            # 以大端（高位在前）方式写入
            txtfile.write(chunk[::-1].hex() + '\n')

def convert_all_bin_to_txt(directory='.'):
    for filename in os.listdir(directory):
        if filename.endswith('.bin'):
            bin_path = os.path.join(directory, filename)
            txt_path = os.path.splitext(bin_path)[0] + '.txt'
            print(f'Converting {filename} -> {os.path.basename(txt_path)}')
            bin_to_txt(bin_path, txt_path)

if __name__ == '__main__':
    convert_all_bin_to_txt()
