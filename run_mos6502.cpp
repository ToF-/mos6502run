#include <stdio.h>
#include <stdlib.h>
#include "mos6502.h"
#include "run_memory.h"

uint16_t origin = 0x0200;

uint8_t memory[0x10000];

char buffer[256];

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
    if (address == 0xFFFE) {
        exit(0);
    }
    return memory[address];
}

void ClockCycle(mos6502 *mpu) {
    mpu->PrintState(buffer);
    printf("%s", buffer);
}
void MemoryWrite(uint16_t address, uint8_t value) {
    memory[address] = value;
}


int main() {
    mos6502 mpu = mos6502(MemoryRead, MemoryWrite, ClockCycle);
    init_memory();
    mpu.Reset();
    mpu.RunEternally();
    mpu.PrintState(buffer);
    printf("%s", buffer);
    return 0;
}
