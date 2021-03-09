  .INCLUDE "./includes/lcd.s"

  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  SETUP_VIA_FOR_LCD
  SEND_INSTRUCTION (LCD_CMD_FUNCTION_SET | LCD_ARG_8_BITS | LCD_ARG_2_LINES | LCD_ARG_5_PER_8_DOTS)

start:
  SEND_INSTRUCTION (LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_OFF | LCD_ARG_CURSOR_OFF | LCD_ARG_BLINKING_OFF)

; Load custom chars

  SEND_INSTRUCTION (LCD_CMD_SET_CGRAM_ADDRESS | $0)
  LDX #$0
fill_custom_characters:
  LDY #$0
fill_custom_character_row:
  TYA
  CPX
  BCC ones_row
zeros_row:
  LDA #$0
  WRITE_DATA_IN_A
  JMP repeat
ones_row:
  LDA #$ff
  WRITE_DATA_IN_A
repeat:
  TYA
  INY
  CPY #$8
  BNE fill_custom_character_row

  INX
  CPX #$8
  BNE fill_custom_characters

  SEND_INSTRUCTION (LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_ON | LCD_ARG_CURSOR_ON | LCD_ARG_BLINKING_OFF)
  SEND_INSTRUCTION (LCD_CMD_ENTRY_MODE_SET | LCD_ARG_CURSOR_AUTO_INCREMENT | LCD_ARG_DISABLE_DISPLAY_SHIFT)
  SEND_INSTRUCTION (LCD_CMD_CLEAR_DISPLAY)

  LDX #$0
print_next_char:
  TXA
  WRITE_DATA_IN_A
  INX
  CPX #8
  BNE print_next_char

loop:
  NOP
  JMP loop

  ; reset vector
  .ORG  $fffc
  .WORD reset
  .WORD $0000
