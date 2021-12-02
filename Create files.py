#!/usr/bin/env python3

f1 = 'AoC2021/Data'
f2 = 'AoC2021/Test'

for i in range(1, 26):
	file_name = f'{f1}/Day{i}.txt'
	f = open(file_name, 'w')
	f.close()
	
	file_name = f'{f2}/Day{i}.txt'
	f = open(file_name, 'w')
	f.close()