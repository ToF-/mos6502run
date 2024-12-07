convert_dec
    lda #$00
    sta dcb_result
    sta dcb_result+1
    sta dcb_result+2
    sta dcb_result+3
    sta dcb_result+4
    sed
    ldx #32
loop_convert_dec
    asl param
    rol param+1
    rol param+2
    rol param+3
    lda dcb_result+4
    adc dcb_result+4
    sta dcb_result+4
    lda dcb_result+3
    adc dcb_result+3
    sta dcb_result+3
    lda dcb_result+2
    adc dcb_result+2
    sta dcb_result+2
    lda dcb_result+1
    adc dcb_result+1
    sta dcb_result+1
    lda dcb_result
    adc dcb_result
    sta dcb_result
    dex
    bne loop_convert_dec
    cld
    rts

print_convert_dec
    ldy #0
loop_print_dec
    lda dcb_result,y
    lsr
    lsr
    lsr
    lsr
    ora #$30
    jsr chrout
    lda dcb_result,y
    and #$0F
    ora #$30
    jsr chrout
    iny
    cpy #5
    bne loop_print_dec
    rts


param
    .dsb 4,0

dcb_result
    .dsb 5,0
