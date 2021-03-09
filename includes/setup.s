  .MACRO SETUP_STACK
    ; stack starts from 01ff
    LDX #$ff
    TXS
  .ENDMACRO

FUNC_sleep:
  PHA
  TYA
  PHA

  LDY #0

sleep__loop:
  NOP
  INY
  CPY #$fe
  BNE sleep__loop

  PLA
  TAY

  PLA
  RTS