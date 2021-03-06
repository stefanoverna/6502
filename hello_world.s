  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

main:
  ; stack starts from 01ff
  LDX #$ff
  TXS

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

  LDA #<greeting
  STA ARG_Pointer
  LDA #>greeting
  STA ARG_Pointer + 1
  JSR FUNC_print_string__ARG_Pointer

  JSR FUNC_sleep

  JMP start

  .INCLUDE "./includes/setup.s"
  .INCLUDE "./includes/lcd.s"

greeting:
  .STRING "Hello, world!"

  ; reset vector
  .ORG  $fffc
  .WORD main
  .WORD $0000
