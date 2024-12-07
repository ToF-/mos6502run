
*=$0200
; doesn't work for space padding when 0
spike_loop
    lda param
    sta num
    lda param+1
    sta num+1
    lda param+2
    sta num+2
    lda param+3
    sta num+3
    lda #$20
    sta pad
    jsr PrDec32
    lda #$0D
    jsr chrout
    lda #$0A
    jsr chrout
    clc
    lda param
    adc #$01
    sta param
    lda param+1
    adc #$01
    sta param+1
    lda param+2
    adc #$01
    sta param+2
    lda param+3
    adc #$01
    sta param+3
    lda #$30
    sta pad
    jmp spike_loop
    rts
       
; ---------------------------
; Print 32-bit decimal number
; ---------------------------
; On entry, num=number to print
;           pad=0 or pad character (eg '0' or ' ')
; On entry at PrDec32Lp1,
;           Y=(number of digits)*4-4, eg 36 for 10 digits
; On exit,  A,X,Y,num,pad corrupted
; Size      129 bytes
; -----------------------------------------------------------------
PrDec32
    LDY #36     ; Offset to powers of ten
PrDec32Lp1
    LDX #$FF
    SEC         ; Start with digit=-1
PrDec32Lp2
    LDA num+0
    SBC PrDec32Tens+0,Y
    STA num+0  ; Subtract current tens
    LDA num+1
    SBC PrDec32Tens+1,Y
    STA num+1
    LDA num+2
    SBC PrDec32Tens+2,Y
    STA num+2
    LDA num+3
    SBC PrDec32Tens+3,Y
    STA num+3
    INX
    BCS PrDec32Lp2                       ; Loop until <0
    LDA num+0
    ADC PrDec32Tens+0,Y
    STA num+0  ; Add current tens back in
    LDA num+1
    ADC PrDec32Tens+1,Y
    STA num+1
    LDA num+2
    ADC PrDec32Tens+2,Y
    STA num+2
    LDA num+3
    ADC PrDec32Tens+3,Y
    STA num+3
    TXA
    BNE PrDec32Digit                     ; Not zero, print it
    LDA pad
    BNE PrDec32Print
    BEQ PrDec32Next ; pad<>0, use it
PrDec32Digit
    LDX #'0'
    STX pad                      ; No more zero padding
    ORA #'0'                              ; Print this digit
PrDec32Print
    JSR chrout
PrDec32Next
    DEY
    DEY
    DEY
    DEY
    BPL PrDec32Lp1           ; Loop for next digit
    RTS

pad
    .byte $20
num
    .word 0, 0
PrDec32Tens
    .byte $01, $00, $00, $00
    .byte $0A, $00, $00, $00
    .byte $64, $00, $00, $00
    .byte $E8, $03, $00, $00
    .byte $10, $27, $00, $00
    .byte $A0, $86, $01, $00
    .byte $40, $42, $0F, $00
    .byte $80, $96, $98, $00
    .byte $00, $E1, $F5, $05
    .byte $00, $CA, $9A, $3B


param
    .word $FFFF, $FFFF

counter
    .byte 0
