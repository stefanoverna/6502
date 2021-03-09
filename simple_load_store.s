  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

setup:
  LDX #$ff
  TXS

start:
  JSR foo
  JMP start

foo:
  NOP
  RTS

  ; reset vector
  .ORG  $fffc
  .WORD setup
  .WORD $0000
