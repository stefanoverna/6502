  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  ; set all lines of the VIA to be outputs
  LDA #%11111111
  STA $6002

loop:
  LDA #%01010101
  STA $6000

  LDA #%10101010
  STA $6000

  JMP loop

  ; reset vector
  .ORG  $fffc
  .word reset
  .word $0000