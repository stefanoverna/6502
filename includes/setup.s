  .MACRO SETUP_STACK
    ; stack starts from 01ff
    LDX #$ff
    TXS
  .ENDMACRO