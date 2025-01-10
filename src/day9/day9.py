import os
input = open("data/day9.input").read()

tape = []
cnt = 0
spare = []
tofill = []
seq = []
for i in input:
    if cnt % 2 == 1:
        spare += list(range(len(tape), len(tape) + int(i)))
    else:
        tofill += [[cnt // 2 for _ in range(int(i))]]
        seq += [(cnt // 2, len(tape) + j) for j in range(int(i))]
    tape += [0 for _ in range(int(i))]
    cnt += 1
tofill.reverse()
tofill = [item for lst in tofill for item in lst]
print(seq)
print(list(zip(tofill, spare)))
print(len(seq))
a = sum(cnt * loc for cnt, loc in seq if loc < len(seq))
b = sum(cnt * loc for cnt, loc in zip(tofill, spare) if loc < len(seq))
print(a + b)
