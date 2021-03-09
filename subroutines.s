  .INCLUDE "./includes/setup.s"
  .INCLUDE "./includes/lcd.s"

  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

reset:
  SETUP_STACK

  JSR FUNC_setup_via_for_lcd

  LDA #(LCD_CMD_FUNCTION_SET | LCD_ARG_8_BITS | LCD_ARG_2_LINES | LCD_ARG_5_PER_8_DOTS)
  JSR FUNC_send_lcd_instruction__A

  LDA #(LCD_CMD_SETUP_DISPLAY | LCD_ARG_DISPLAY_ON | LCD_ARG_CURSOR_ON | LCD_ARG_BLINKING_OFF)
  JSR FUNC_send_lcd_instruction__A

  LDA #(LCD_CMD_ENTRY_MODE_SET | LCD_ARG_CURSOR_AUTO_INCREMENT | LCD_ARG_DISABLE_DISPLAY_SHIFT)
  JSR FUNC_send_lcd_instruction__A

start:
  LDA #(LCD_CMD_CLEAR_DISPLAY)
  JSR FUNC_send_lcd_instruction__A

  LDA #"X"
  JSR FUNC_print_char__A

  LDA greeting
  JSR FUNC_print_string__A

  JSR FUNC_sleep

  JMP start

greeting:
  .STRING " sieee!!"

  ; reset vector
  .ORG  $fffc
  .WORD reset
  .WORD $0000
