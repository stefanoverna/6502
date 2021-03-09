  .INCLUDE "./includes/lcd.s"

  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  ; stack starts from 01ff
  LDX #$ff
  TXS

  SETUP_VIA_FOR_LCD
  SEND_INSTRUCTION (LCD_CMD_FUNCTION_SET | LCD_ARG_8_BITS | LCD_ARG_2_LINES | LCD_ARG_5_PER_8_DOTS)

start:
  SEND_INSTRUCTION (LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_OFF | LCD_ARG_CURSOR_OFF | LCD_ARG_BLINKING_OFF)

; Load custom chars

  SEND_INSTRUCTION (LCD_CMD_SET_CGRAM_ADDRESS | $0)
  LDX #$0
fill_custom_characters:
  LDA custom_character, X
  WRITE_DATA_IN_A

  INX
  CPX #(8 * 3 - 1)
  BNE fill_custom_characters

  SEND_INSTRUCTION (LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_ON | LCD_ARG_CURSOR_ON | LCD_ARG_BLINKING_OFF)
  SEND_INSTRUCTION (LCD_CMD_ENTRY_MODE_SET | LCD_ARG_CURSOR_AUTO_INCREMENT | LCD_ARG_DISABLE_DISPLAY_SHIFT)

outer_loop:
  LDX #$0

; Iterate 3 times (one for each emoji)

inner_loop:
  SEND_INSTRUCTION (LCD_CMD_CLEAR_DISPLAY)

  ; print custom char
  TXA
  WRITE_DATA_IN_A

  LDY #0
print_greeting:
  LDA greeting, Y
  CMP #$0
  BEQ done_print_greeting
  WRITE_DATA_IN_A
  INY
  JMP print_greeting

done_print_greeting:
  LDY #0

sleep:
  INY
  CPY #$fe
  BNE sleep

  INX
  CPX #3
  BNE inner_loop

  JMP outer_loop

custom_character:
  ; :)
  .BYTE %00000
  .BYTE %00000
  .BYTE %01010
  .BYTE %00000
  .BYTE %10001
  .BYTE %01110
  .BYTE %00000
  .BYTE %00000
  ; :(
  .BYTE %00000
  .BYTE %00000
  .BYTE %01010
  .BYTE %00000
  .BYTE %00000
  .BYTE %01110
  .BYTE %10001
  .BYTE %00000
  ; :0
  .BYTE %00000
  .BYTE %00000
  .BYTE %01010
  .BYTE %00000
  .BYTE %01110
  .BYTE %10001
  .BYTE %01110
  .BYTE %00000

greeting:
  .STRING " Ciao Puppa!!"

  ; reset vector
  .ORG  $fffc
  .WORD reset
  .WORD $0000
