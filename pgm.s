* = $0200
SED
LDA #48
CLC
ADC #03
CLD
JSR chrout
LDA #$0A
JSR chrout
LDA #$0D
JSR chrout
RTS
