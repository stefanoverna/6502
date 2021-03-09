DATA_DIRECTION_REGISTER_B = $6002
REGISTER_B = $6000

DATA_DIRECTION_REGISTER_A = $6003
REGISTER_A = $6001

DISPLAY_ENABLE_PIN = %10000000
DISPLAY_RW_PIN     = %01000000
DISPLAY_RS_PIN     = %00100000

  .MACRO SEND_INSTRUCTION, instruction
    LDA #0                     ; clear RS/RW/E
    STA REGISTER_A

    LDA #\1                    ; fill in DBX pins...
    STA REGISTER_B

    LDA #DISPLAY_ENABLE_PIN    ; set and..
    STA REGISTER_A

    LDA #0                     ; ...clear ENABLE pin to send command
    STA REGISTER_A
  .ENDMACRO

  .MACRO WRITE_DATA, char
    LDA #DISPLAY_RS_PIN        ; set RS ping
    STA REGISTER_A

    LDA #\1                    ; fill in DBX pins...
    STA REGISTER_B

    LDA #(DISPLAY_RS_PIN | DISPLAY_ENABLE_PIN)
    STA REGISTER_A

    LDA #DISPLAY_RS_PIN        ; set and clear ENABLE pin to send command
    STA REGISTER_A
  .ENDMACRO

  ; tells the compiler where this code will
  ; be available (from the processor's perspective)
  .ORG $8000

; S/C  = 1:  Display shift
; S/C  = 0:  Cursor move
; R/L  = 1:  Shift to the right
; R/L  = 0:  Shift to the left
; BF   = 1:  Internally operating
; BF   = 0:  Instructions acceptable

reset:
  ; set all lines of the VIA register B to outputs
  LDA #%11111111
  STA DATA_DIRECTION_REGISTER_B

  ; set top 3 lines of the VIA register A to outputs
  LDA #%11100000
  STA DATA_DIRECTION_REGISTER_A

  ; function set:  8 bits communication, 2 lines, 5x8 dots font
  ; 001 DL N F — —
  ; DL   = 1:  8 bits, DL = 0:  4 bits
  ; N    = 1:  2 lines, N = 0:  1 line
  ; F    = 1:  5 × 10 dots, F = 0:  5 × 8 dots
  SEND_INSTRUCTION %00111000

  ; display on/off:  display on, cursor on, blink off
  ; 00001 D C B
  ; D    = 1:  Display ON
  ; C    = 1:  Cursor ON
  ; B    = 1:  Blinking ON
  SEND_INSTRUCTION %00001110

  ; entry mode set:  cursor direction: increment, no display shift
  ; 000001 I/D S
  ; I/D  = 1:  Increment
  ; I/D  = 0:  Decrement
  ; S    = 1:  Accompanies display shift
  SEND_INSTRUCTION %00000110

start:
  ; clear display
  SEND_INSTRUCTION %00000001

  WRITE_DATA "C"
  WRITE_DATA "i"
  WRITE_DATA "a"
  WRITE_DATA "o"
  
  JMP start

  ; reset vector
  .ORG  $fffc
  .word reset
  .word $0000
