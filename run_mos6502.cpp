#include <stdio.h>
#include <stdlib.h>
#include "mos6502.h"
#include "run_memory.h"

uint16_t origin = 0x0200;

uint8_t memory[0x10000];

void init_memory() {
    unsigned index;
    for(index = 0; index < 0x10000; memory[index++] = 0);
    for(index = 0; index < BINARY_SIZE; index++) {
        memory[index + origin] = binary[index];
    }
    memory[0xFFFC] = origin & 0x00FF;
    memory[0xFFFD] = origin >> 8;
}

uint8_t MemoryRead(uint16_t address) {
    return memory[address];
}

void MemoryWrite(uint16_t address, uint8_t value) {
    memory[address] = value;
}

char buffer[256];

int main() {
    mos6502 mpu = mos6502(MemoryRead, MemoryWrite);
    init_memory();
    mpu.Reset();
    mpu.PrintState(buffer);
    printf("%s", buffer);
    return 0;
}
