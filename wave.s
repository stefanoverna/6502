  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

index = $100
forward = $101

main:
  ; stack starts from 01ff
  LDX #$ff
  TXS

  JSR FUNC_setup_via_for_lcd

  LDA #(LCD_CMD_FUNCTION_SET | LCD_ARG_8_BITS | LCD_ARG_1_LINE | LCD_ARG_5_PER_8_DOTS)
  JSR FUNC_send_lcd_instruction__A

generate_chars:
  LDA #(LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_OFF | LCD_ARG_CURSOR_OFF | LCD_ARG_BLINKING_OFF)
  JSR FUNC_send_lcd_instruction__A

  LDA #(LCD_CMD_SET_CGRAM_ADDRESS | $0)
  JSR FUNC_send_lcd_instruction__A

  ; x: n-th char pattern
  LDX #$0
loop_generate_char_pattern:

  LDA #$0
  STA index
loop_generate_row:

  ; if index < x
  TXA
  CMP index
  BCC set_row_as_empty

set_row_as_full:
  LDA #$ff
  JMP write_row

set_row_as_empty:
  LDA #$0

write_row:
  JSR FUNC_print_char__A

  INC index
  LDA index
  CMP #8
  BNE loop_generate_row

end_loop_generate_char_pattern:
  INX
  CPX #8
  BNE loop_generate_char_pattern

start:
  LDA #(LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_ON | LCD_ARG_CURSOR_ON | LCD_ARG_BLINKING_OFF)
  JSR FUNC_send_lcd_instruction__A

  LDA #(LCD_CMD_ENTRY_MODE_SET | LCD_ARG_CURSOR_AUTO_INCREMENT | LCD_ARG_DISABLE_DISPLAY_SHIFT)
  JSR FUNC_send_lcd_instruction__A

start_from_beginning:
  LDA #$0
  STA index

loop_iteration:
  LDA #(LCD_CMD_CLEAR_DISPLAY)
  JSR FUNC_send_lcd_instruction__A

  LDX #$0
loop_print_char:
  TXA
  ADC index
  JSR FUNC_print_char__A

  INX
  CPX #$16
  BNE loop_print_char

  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep
  JSR FUNC_sleep

  INC index
  LDA index
  CMP #$ff
  BEQ start_from_beginning

  JMP loop_iteration

  .INCLUDE "./includes/setup.s"
  .INCLUDE "./includes/lcd.s"

  ; reset vector
  .ORG  $fffc
  .WORD main
  .WORD $0000
