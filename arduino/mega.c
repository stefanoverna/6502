// expressed from LSB to MSB
const char ADDR[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
// expressed from LSB to MSB
const char DATA[] = {53, 51, 49, 47, 45, 43, 41, 39};
#define CLOCK 20
#define READ_WRITE 11
#define CE_B 31

typedef struct
{
  uint8_t code;
  char *name;
} opCode;

const opCode opCodes[]{
    {0x00, "BRK"},
    {0x01, "ORA"},
    {0x02, "KIL"},
    {0x03, "SLO"},
    {0x04, "NOP"},
    {0x05, "ORA"},
    {0x06, "ASL"},
    {0x07, "SLO"},
    {0x08, "PHP"},
    {0x09, "ORA"},
    {0x0A, "ASL"},
    {0x0B, "ANC"},
    {0x0C, "NOP"},
    {0x0D, "ORA"},
    {0x0E, "ASL"},
    {0x0F, "SLO"},
    {0x10, "BPL"},
    {0x11, "ORA"},
    {0x12, "KIL"},
    {0x13, "SLO"},
    {0x14, "NOP"},
    {0x15, "ORA"},
    {0x16, "ASL"},
    {0x17, "SLO"},
    {0x18, "CLC"},
    {0x19, "ORA"},
    {0x1A, "NOP"},
    {0x1B, "SLO"},
    {0x1C, "NOP"},
    {0x1D, "ORA"},
    {0x1E, "ASL"},
    {0x1F, "SLO"},
    {0x20, "JSR"},
    {0x21, "AND"},
    {0x22, "KIL"},
    {0x23, "RLA"},
    {0x24, "BIT"},
    {0x25, "AND"},
    {0x26, "ROL"},
    {0x27, "RLA"},
    {0x28, "PLP"},
    {0x29, "AND"},
    {0x2A, "ROL"},
    {0x2B, "ANC"},
    {0x2C, "BIT"},
    {0x2D, "AND"},
    {0x2E, "ROL"},
    {0x2F, "RLA"},
    {0x30, "BMI"},
    {0x31, "AND"},
    {0x32, "KIL"},
    {0x33, "RLA"},
    {0x34, "NOP"},
    {0x35, "AND"},
    {0x36, "ROL"},
    {0x37, "RLA"},
    {0x38, "SEC"},
    {0x39, "AND"},
    {0x3A, "NOP"},
    {0x3B, "RLA"},
    {0x3C, "NOP"},
    {0x3D, "AND"},
    {0x3E, "ROL"},
    {0x3F, "RLA"},
    {0x40, "RTI"},
    {0x41, "EOR"},
    {0x42, "KIL"},
    {0x43, "SRE"},
    {0x44, "NOP"},
    {0x45, "EOR"},
    {0x46, "LSR"},
    {0x47, "SRE"},
    {0x48, "PHA"},
    {0x49, "EOR"},
    {0x4A, "LSR"},
    {0x4B, "ALR"},
    {0x4C, "JMP"},
    {0x4D, "EOR"},
    {0x4E, "LSR"},
    {0x4F, "SRE"},
    {0x50, "BVC"},
    {0x51, "EOR"},
    {0x52, "KIL"},
    {0x53, "SRE"},
    {0x54, "NOP"},
    {0x55, "EOR"},
    {0x56, "LSR"},
    {0x57, "SRE"},
    {0x58, "CLI"},
    {0x59, "EOR"},
    {0x5A, "NOP"},
    {0x5B, "SRE"},
    {0x5C, "NOP"},
    {0x5D, "EOR"},
    {0x5E, "LSR"},
    {0x5F, "SRE"},
    {0x60, "RTS"},
    {0x61, "ADC"},
    {0x62, "KIL"},
    {0x63, "RRA"},
    {0x64, "NOP"},
    {0x65, "ADC"},
    {0x66, "ROR"},
    {0x67, "RRA"},
    {0x68, "PLA"},
    {0x69, "ADC"},
    {0x6A, "ROR"},
    {0x6B, "ARR"},
    {0x6C, "JMP"},
    {0x6D, "ADC"},
    {0x6E, "ROR"},
    {0x6F, "RRA"},
    {0x70, "BVS"},
    {0x71, "ADC"},
    {0x72, "KIL"},
    {0x73, "RRA"},
    {0x74, "NOP"},
    {0x75, "ADC"},
    {0x76, "ROR"},
    {0x77, "RRA"},
    {0x78, "SEI"},
    {0x79, "ADC"},
    {0x7A, "NOP"},
    {0x7B, "RRA"},
    {0x7C, "NOP"},
    {0x7D, "ADC"},
    {0x7E, "ROR"},
    {0x7F, "RRA"},
    {0x80, "NOP"},
    {0x81, "STA"},
    {0x82, "NOP"},
    {0x83, "SAX"},
    {0x84, "STY"},
    {0x85, "STA"},
    {0x86, "STX"},
    {0x87, "SAX"},
    {0x88, "DEY"},
    {0x89, "NOP"},
    {0x8A, "TXA"},
    {0x8B, "XAA"},
    {0x8C, "STY"},
    {0x8D, "STA"},
    {0x8E, "STX"},
    {0x8F, "SAX"},
    {0x90, "BCC"},
    {0x91, "STA"},
    {0x92, "KIL"},
    {0x93, "AHX"},
    {0x94, "STY"},
    {0x95, "STA"},
    {0x96, "STX"},
    {0x97, "SAX"},
    {0x98, "TYA"},
    {0x99, "STA"},
    {0x9A, "TXS"},
    {0x9B, "TAS"},
    {0x9C, "SHY"},
    {0x9D, "STA"},
    {0x9E, "SHX"},
    {0x9F, "AHX"},
    {0xA0, "LDY"},
    {0xA1, "LDA"},
    {0xA2, "LDX"},
    {0xA3, "LAX"},
    {0xA4, "LDY"},
    {0xA5, "LDA"},
    {0xA6, "LDX"},
    {0xA7, "LAX"},
    {0xA8, "TAY"},
    {0xA9, "LDA"},
    {0xAA, "TAX"},
    {0xAB, "LAX"},
    {0xAC, "LDY"},
    {0xAD, "LDA"},
    {0xAE, "LDX"},
    {0xAF, "LAX"},
    {0xB0, "BCS"},
    {0xB1, "LDA"},
    {0xB2, "KIL"},
    {0xB3, "LAX"},
    {0xB4, "LDY"},
    {0xB5, "LDA"},
    {0xB6, "LDX"},
    {0xB7, "LAX"},
    {0xB8, "CLV"},
    {0xB9, "LDA"},
    {0xBA, "TSX"},
    {0xBB, "LAS"},
    {0xBC, "LDY"},
    {0xBD, "LDA"},
    {0xBE, "LDX"},
    {0xBF, "LAX"},
    {0xC0, "CPY"},
    {0xC1, "CMP"},
    {0xC2, "NOP"},
    {0xC3, "DCP"},
    {0xC4, "CPY"},
    {0xC5, "CMP"},
    {0xC6, "DEC"},
    {0xC7, "DCP"},
    {0xC8, "INY"},
    {0xC9, "CMP"},
    {0xCA, "DEX"},
    {0xCB, "AXS"},
    {0xCC, "CPY"},
    {0xCD, "CMP"},
    {0xCE, "DEC"},
    {0xCF, "DCP"},
    {0xD0, "BNE"},
    {0xD1, "CMP"},
    {0xD2, "KIL"},
    {0xD3, "DCP"},
    {0xD4, "NOP"},
    {0xD5, "CMP"},
    {0xD6, "DEC"},
    {0xD7, "DCP"},
    {0xD8, "CLD"},
    {0xD9, "CMP"},
    {0xDA, "NOP"},
    {0xDB, "DCP"},
    {0xDC, "NOP"},
    {0xDD, "CMP"},
    {0xDE, "DEC"},
    {0xDF, "DCP"},
    {0xE0, "CPX"},
    {0xE1, "SBC"},
    {0xE2, "NOP"},
    {0xE3, "ISC"},
    {0xE4, "CPX"},
    {0xE5, "SBC"},
    {0xE6, "INC"},
    {0xE7, "ISC"},
    {0xE8, "INX"},
    {0xE9, "SBC"},
    {0xEA, "NOP"},
    {0xEB, "SBC"},
    {0xEC, "CPX"},
    {0xED, "SBC"},
    {0xEE, "INC"},
    {0xEF, "ISC"},
    {0xF0, "BEQ"},
    {0xF1, "SBC"},
    {0xF2, "KIL"},
    {0xF3, "ISC"},
    {0xF4, "NOP"},
    {0xF5, "SBC"},
    {0xF6, "INC"},
    {0xF7, "ISC"},
    {0xF8, "SED"},
    {0xF9, "SBC"},
    {0xFA, "NOP"},
    {0xFB, "ISC"},
    {0xFC, "NOP"},
    {0xFD, "SBC"},
    {0xFE, "INC"},
    {0xFF, "ISC"},
};

void setup()
{
  for (int n = 0; n < 16; n += 1)
  {
    pinMode(ADDR[n], INPUT);
  }
  for (int n = 0; n < 8; n += 1)
  {
    pinMode(DATA[n], INPUT);
  }
  pinMode(CLOCK, INPUT);
  pinMode(READ_WRITE, INPUT);
  pinMode(CE_B, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);

  Serial.begin(115200);

  Serial.println("Partiti!");
}

void onClock()
{
  char output[25];

  unsigned int address = 0;
  for (int n = 15; n >= 0; n -= 1)
  {
    int bit = digitalRead(ADDR[n]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }

  Serial.print("   ");

  unsigned int data = 0;
  for (int n = 7; n >= 0; n -= 1)
  {
    int bit = digitalRead(DATA[n]) ? 1 : 0;
    Serial.print(bit);
    data = (data << 1) + bit;
  }

  char *opCodeName = "";

  for (uint8_t i = 0; i < sizeof(opCodes) / sizeof(opCode); ++i)
  {
    if (opCodes[i].code == data)
    {
      opCodeName = opCodes[i].name;
      break;
    }
  }

  sprintf(output, "   %04x  %c %c %02x %s", address, digitalRead(READ_WRITE) ? 'r' : 'W', digitalRead(CE_B) ? 'F' : 'T', data, opCodeName);
  Serial.println(output);
}

void loop()
{
}