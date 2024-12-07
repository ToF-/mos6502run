#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>
#include "mos6502.h"
#include "run_memory.h"

#define NEGATIVE  0x80
#define OVERFLOW  0x40
#define CONSTANT  0x20
#define BREAK     0x10
#define DECIMAL   0x08
#define INTERRUPT 0x04
#define ZERO      0x02
#define CARRY     0x01

#define CHAR_OUT 0x00FF
#define CHAR_IN  0x00FE
uint16_t origin = 0x0200;

uint8_t memory[0x10000];

char buffer[256];

int trace = 0;

void init_memory() {
    unsigned index;
    for(index = 0; index < 0x10000; memory[index++] = 0);
    for(index = 0; index < BINARY_SIZE; index++) {
        memory[index + origin] = binary[index];
    }
    memory[0xFFFC] = origin & 0x00FF;
    memory[0xFFFD] = origin >> 8;
}

void PrintState(mos6502 *mpu, char *buffer) {
    uint8_t status = mpu->GetP();
    snprintf(buffer, 128, "PC:   A  X  Y  SP  NV-BDIZC\n%04X  %02X %02X %02X %02X  %c%c-%c%c%c%c%c\n\n", 
            mpu->GetPC(),
            mpu->GetA(),
            mpu->GetX(),
            mpu->GetY(),
            mpu->GetS(),
            status & NEGATIVE ?  '1' : '0',
            status & OVERFLOW ?  '1' : '0',
            status & BREAK ?     '1' : '0',
            status & DECIMAL ?   '1' : '0',
            status & INTERRUPT ? '1' : '0', 
            status & ZERO ?      '1' : '0',
            status & CARRY ?     '1' : '0');
}

void RunInService(uint16_t address) {
    switch(address) {
        case CHAR_IN:
            int value = getchar();
            memory[address] = value;
            break;
    }
}

uint8_t MemoryRead(uint16_t address) {
    RunInService(address);
    return memory[address];
}

void ClockCycle(mos6502 *mpu) {
    if(trace) {
        PrintState(mpu, buffer);
        printf("%s", buffer);
    }
    if (mpu->GetPC() == 0x0000) {
        exit(0);
    }
}

void RunOutService(uint16_t address, uint8_t value) {
    switch(address) {
        case CHAR_OUT:
            putchar(value);
            break;
    }
}

void MemoryWrite(uint16_t address, uint8_t value) {
    if(trace) {
        printf("MemoryWrite:%04x:%02x\n", address, value);
    }
    RunOutService(address, value);
    memory[address] = value;
}

int main(int argc, char *argv[]) {
    int opt;
    while ((opt = getopt(argc, argv,"t")) != -1) {
        switch(opt) {
            case 't':
                trace = 1;
                break;
        }
    }
    mos6502 mpu = mos6502(MemoryRead, MemoryWrite, ClockCycle);
    init_memory();
    mpu.Reset();
    mpu.RunEternally();
    return 0;
}
