DATA_DIRECTION_REGISTER_B = $6002
REGISTER_B = $6000

DATA_DIRECTION_REGISTER_A = $6003
REGISTER_A = $6001

DISPLAY_ENABLE_PIN = %10000000
DISPLAY_RW_PIN     = %01000000
DISPLAY_RS_PIN     = %00100000

; function set
; 001 DL N F — —
; DL   = 1:  8 bits, DL = 0:  4 bits
; N    = 1:  2 lines, N = 0:  1 line
; F    = 1:  5 × 10 dots, F = 0:  5 × 8 dots

LCD_CMD_FUNCTION_SET  = %00100000

LCD_ARG_8_BITS        = %00010000
LCD_ARG_4_BITS        = %00000000

LCD_ARG_2_LINES       = %00001000
LCD_ARG_1_LINE        = %00000000

LCD_ARG_5_PER_8_DOTS  = %00000100
LCD_ARG_5_PER_10_DOTS = %00000000

; display on/off
; 00001 D C B
; D    = 1:  Display ON
; C    = 1:  Cursor ON
; B    = 1:  Blinking ON

LCD_CMD_SETUP_DISPLAY = %00001000

LCD_ARG_DISPLAY_ON    = %00000100
LCD_ARG_DISPLAY_OFF   = %00000000

LCD_ARG_CURSOR_ON     = %00000010
LCD_ARG_CURSOR_OFF    = %00000000

LCD_ARG_BLINKING_ON   = %00000001
LCD_ARG_BLINKING_OFF  = %00000000

; entry mode set:  cursor direction: increment, no display shift
; 000001 I/D S
; I/D  = 1:  Increment
; I/D  = 0:  Decrement
; S    = 1:  Accompanies display shift
LCD_CMD_ENTRY_MODE_SET         = %00000100

LCD_ARG_CURSOR_AUTO_INCREMENT  = %00000010
LCD_ARG_CURSOR_AUTO_DENCREMENT = %00000000

LCD_ARG_ENABLE_DISPLAY_SHIFT   = %00000001
LCD_ARG_DISABLE_DISPLAY_SHIFT  = %00000000

; set CGRAM (custom fonts) address
; 01 ACG ACG ACG ACG ACG ACG

LCD_CMD_SET_CGRAM_ADDRESS = %01000000

; clear display
; 00000001

LCD_CMD_CLEAR_DISPLAY = %0000001

ARG_Pointer = $01

FUNC_setup_via_for_lcd:
  PHA

  ; set all lines of the VIA register B to outputs
  LDA #%11111111
  STA DATA_DIRECTION_REGISTER_B

  ; set top 3 lines of the VIA register A to outputs
  LDA #%11100000
  STA DATA_DIRECTION_REGISTER_A

  PLA
  RTS

FUNC_send_lcd_instruction__A:
  PHA

  PHA                        ; we push it another time so that we can reuse it below

  LDA #0                     ; clear RS/RW/E
  STA REGISTER_A

  PLA                        ; fill in DBX pins...
  STA REGISTER_B

  LDA #DISPLAY_ENABLE_PIN    ; set and..
  STA REGISTER_A

  LDA #0                     ; ...clear ENABLE pin to send command
  STA REGISTER_A

  PLA
  RTS

FUNC_print_char__A:
  PHA

  STA REGISTER_B

  LDA #DISPLAY_RS_PIN        ; set RS ping
  STA REGISTER_A

  LDA #(DISPLAY_RS_PIN | DISPLAY_ENABLE_PIN)
  STA REGISTER_A

  LDA #DISPLAY_RS_PIN        ; set and clear ENABLE pin to send command
  STA REGISTER_A

  JSR FUNC_sleep

  PLA
  RTS

FUNC_print_string__ARG_Pointer:
  PHA

  TYA
  PHA

  LDY #0
print_string__loop:
  LDA (ARG_Pointer), Y
  CMP #$0
  BEQ print_string__done_printing

  JSR FUNC_print_char__A

  INY
  JMP print_string__loop

print_string__done_printing:
  PLA
  TAY

  PLA
  RTS

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