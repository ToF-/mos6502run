#define CHAR_OUT $FF
#define CHAR_IN  $FE

chrout
    sta CHAR_OUT
    rts

chrin
    lda CHAR_IN
    rts
