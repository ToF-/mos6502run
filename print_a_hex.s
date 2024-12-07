
print_a_hex
    pha
    lsr
    lsr
    lsr
    lsr
    jsr print_hex_digit
    pla
    jsr print_hex_digit
    rts
    
print_hex_digit
    and #$0F
    cmp #$0A
    bcc print_lt_10
    clc
    adc #$7
print_lt_10
    adc #$30
    jsr chrout
    rts
