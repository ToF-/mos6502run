spike: spike.s run_mos6502.cpp
	mkdir -p bin
	xa spike.s -o bin/spike.bin -P spike.lst
	bin2c bin/spike.bin -o run_memory.h
	cc -std=c++11 run_mos6502.cpp mos6502.cpp -o bin/run 
