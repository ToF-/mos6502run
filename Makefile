code:=$(wildcard *.s)
spike: $(code) run_mos6502.cpp
	mkdir -p bin
	xa spike.s -o bin/spike.bin -P spike.lst -l spike.lbl
	bin2c bin/spike.bin -o run_memory.h
	cc -std=c++11 run_mos6502.cpp mos6502.cpp -o bin/run 
