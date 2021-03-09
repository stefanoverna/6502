  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  LDA #$6
  NOP
  LDA #$5
  NOP
  LDA #$4
  NOP
  LDA #$3

  JMP reset

  .word $0000
  .word $0000
  .word $0000
  .word $0000
  .word $0000
  .word $0000
  .word $0000
  .word $0000
  .word $0000