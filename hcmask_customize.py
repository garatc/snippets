import random

def concatenate_list_data(list):
     result= ''
     for element in list:
         result += element
     return result

def two_random_numbers(a,b):
     test = random.random()
     if test < 0.5: return a
     else: return b

output = "9char.hcmask"
file_name = "8char-1l-1u-1d-1s-compliant.hcmask"
string_to_add = "?l"
size = 2

file_lines = []

with open(file_name, 'r') as f:
    for x in f.readlines():
        parts = [x[i:i+size] for i in range(0, len(x), size)]
        random_index = random.randint(0, len(parts) - 2)
        rand = two_random_numbers(0, 1)
        if (rand == 0): parts[random_index] += string_to_add
        else: parts[random_index] = string_to_add + parts[random_index]
        file_lines.append(concatenate_list_data(parts))

with open(output, 'w') as f:
        f.writelines(file_lines)
