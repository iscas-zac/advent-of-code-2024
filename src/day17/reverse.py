a = 1
b = 0b110
c = a ^ b

acc = {}
for ind, dig in enumerate([2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0]):
    tribits = {}
    for b in range(0b111 + 1):
        a = b ^ 0b010
        after_xor_c = dig ^ 0b111
        c = b ^ after_xor_c
        if (c << b) & 0b111 == a >> b << b:
            tribits[((c << b) | a) << 3*ind] = ((0b111 << b) | 0b111) << 3*ind
    acc[ind] = tribits

sum = 0

# conflicts = {}
# for ind1, d1 in acc.items():
#     conflicts[ind1] = {}
#     for ind2, d2 in acc.items():
#         if ind1 == ind2:
#             continue
#         for num1, mask1 in d1.items():
#             conflicts[ind1][num1] = []
#             for num2, mask2 in d2.items():
#                 if (num1 & mask2) ^ (num2 & mask1) != 0:
#                     conflicts[ind1][num1] += [(ind2, num2)]

# print(conflicts)

def find_min_without_conflicts(ind: int, sum: int, sum_mask: int):
    if ind == -1: return sum
    nums = acc[ind].keys()
    nums = list(nums)
    nums.sort()
    for num in nums:
        mask = acc[ind][num]
        if (num & sum_mask) ^ (sum & mask) == 0:
            if res := find_min_without_conflicts(ind - 1, sum | num, sum_mask | mask):
                print(f"{bin(sum).rjust(64)}")
                print(f"{bin(mask).rjust(64)}".replace('0', ' '))
                print(f"{bin(num).rjust(64)}")
                print(f"{bin(sum_mask).rjust(64)}".replace('0', ' '))
                return res
    return None

print(find_min_without_conflicts(15, 0, 0))

breakpoint()

for ind, d in acc.items():
    num = min(num for num in d.keys())
    mask = d[num]
    sum += num
    print(f"{bin(num).rjust(64)}")
    print(f"{bin(mask).rjust(64)}".replace('0', ' '))
    # print(("|" + " " * (1 + ind) * 3).rjust(64))
print(sum)
# for d in acc:
#     for num, mask in d:
#         print(f"{bin(num).rjust(64)}")

# for a in range(0b1111111111111111):
#     b = 0b111
#     b = b ^ 0b010
#     c = a >> b
#     b = c ^ b
#     b = b ^ 0b111
#     if b & 0b111 == 2:
#         print(a)