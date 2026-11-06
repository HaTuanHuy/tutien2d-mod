import sys

with open('src/systems/hac_thi.26ee3a0d1e05.js', 'r', encoding='utf-8') as f:
    code = f.read()

idx = code.find('bat_quai_thach_phan')
if idx != -1:
    print(code[max(0, idx - 200):min(len(code), idx + 1500)])
else:
    print("Not found")

