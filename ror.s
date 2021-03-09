  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  ; set all lines of the VIA to be outputs
  LDA #%11111111
  STA $6002

  LDA #%10100000
  STA $6000

loop:
  ROR
  STA $6000

  JMP loop

  ; reset vector
  .ORG  $fffc
  .word reset
  .word $0000