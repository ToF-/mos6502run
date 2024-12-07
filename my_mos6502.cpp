#include <stdio.h>
#include <stdlib.h>
#include "mos6502.h"

uint8_t MemoryRead(uint16_t address);
void MemoryWrite(uint16_t address, uint8_t value);

uint8_t MemoryRead(uint16_t address) {
    return 0;
}

void MemoryWrite(uint16_t address, uint8_t value) {

}

int main() {
    mos6502 mpu = mos6502(MemoryRead, MemoryWrite);
    mpu.Reset();
    printf("%04x\n", mpu.GetPC());
    return 0;
}
