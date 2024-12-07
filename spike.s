
*=$0200

    lda #$01
    sta param
    lda #$02
    sta param+1
    lda #$04
    sta param+2
    lda #$08
    sta param+3
    jsr convert_dec
    jsr print_convert_dec
    lda #$0D
    jsr chrout
    lda #$0A
    jsr chrout
    rts


#include "convert_dec.s"
#include "print_a_hex.s"
#include "bios.s"

