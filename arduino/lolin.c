#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char *ssid = "Vodafone-51147367";
const char *password = "LittleB0bbyTables";

const char *body = "<head><meta name=\"viewport\" content=\"width=device-width\"><style>a { color: #504888;padding: 40px;display: block;background: #a9e4ee45;margin-bottom: 20px;border-radius: 10px;font-size: 20px;font-family: arial;text-align: center;text-decoration: none;font-weight: bold; }</style></head><a href=\"/reset\">Reset</a> <a href=\"/start_clock\">Start</a> <a href=\"/stop_clock\">Stop</a> <a href=\"/step\">Step</a> <a href=\"/toggle\">Toggle!</a>";

bool clockOn = false;
bool cpuActive = true;

ESP8266WebServer server(80);

#define CPU_CLK 2   // D4
#define CPU_RES_B 0 // D3
#define CPU_BE 4    // D2

#define ROM_WE_B 5  // D1
#define ROM_OE_B 15 // D8

#define SHIFT_OE_B 16  // D0
#define SHIFT_SER 13   // D7
#define SHIFT_RCLK 12  // D6 -> put into output registers
#define SHIFT_SRCLK 14 // D5 -> advance

// the setup function runs once when you press reset or power the board
void setup()
{
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(CPU_CLK, OUTPUT);
  pinMode(CPU_RES_B, OUTPUT);
  pinMode(CPU_BE, OUTPUT);

  pinMode(ROM_WE_B, OUTPUT);
  pinMode(ROM_OE_B, OUTPUT);

  pinMode(SHIFT_OE_B, OUTPUT);
  pinMode(SHIFT_SER, OUTPUT);
  pinMode(SHIFT_RCLK, OUTPUT);
  pinMode(SHIFT_SRCLK, OUTPUT);

  cpuMaster();

  delay(1000);

  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.println("Waiting to connect...");
  }

  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  Serial.println("Starting web server...");

  server.on("/", []() {
    Serial.println("/");
    server.send(200, "text/html", body);
  });

  server.on("/reset", []() {
    if (cpuActive)
    {
      Serial.println("Reset");
      reset();
    }
    else
    {
      Serial.println("Cannot reset");
    }
    server.sendHeader("Location", "/");
    server.send(301, "text/html", "");
  });

  server.on("/stop_clock", []() {
    if (cpuActive)
    {
      Serial.println("Stop clock");
      clockOn = false;
    }
    else
    {
      Serial.println("Cannot stop clock");
    }
    server.sendHeader("Location", "/");
    server.send(301, "text/html", "");
  });

  server.on("/start_clock", []() {
    if (cpuActive)
    {
      Serial.println("Start clock");
      clockOn = true;
    }
    else
    {
      Serial.println("Cannot start clock");
    }
    server.sendHeader("Location", "/");
    server.send(301, "text/html", "");
  });

  server.on("/step", []() {
    if (cpuActive)
    {
      Serial.println("Step clock");
      stepClock();
    }
    else
    {
      Serial.println("Cannot step");
    }
    server.sendHeader("Location", "/");
    server.send(301, "text/html", "");
  });

  server.on("/write", []() {
    String body = server.arg("plain");

    char output[35];
    sprintf(output, "Writing %d bytes", body.length());
    Serial.println(output);

    cpuActive = false;
    clockOn = false;
    shiftRegistersMasterForWrite();

    for (word address = 0; address < body.length(); address++)
    {
      writeEEPROM(address, body[address]);
      //      digitalWrite(CPU_CLK, HIGH);
      //      delay(2);
      //      digitalWrite(CPU_CLK, LOW);
    }

    Serial.println("Activate CPU!");
    cpuActive = true;
    cpuMaster();
    reset();

    server.sendHeader("Location", "/");
    server.send(301, "text/html", "");
  });

  server.begin();
}

void loop()
{
  server.handleClient();

  if (clockOn)
  {
    digitalWrite(CPU_CLK, HIGH);
    digitalWrite(CPU_CLK, LOW);
  }
}

//  CE <-> 1 - QA
// A14 <-> 1 - QB
// A13 <-> 1 - QC
// A12 <-> 1 - QD
// A11 <-> 1 - QE
// A10 <-> 1 - QF
//  A9 <-> 1 - QG
//  A8 <-> 1 - QH
//
//  A7 <-> 2 - QA
//  A6 <-> 2 - QB
//  A5 <-> 2 - QC
//  A4 <-> 2 - QD
//  A3 <-> 2 - QE
//  A2 <-> 2 - QF
//  A1 <-> 2 - QG
//  A0 <-> 2 - QH
//
//  D0 <-> 3 - QA
//  D1 <-> 3 - QB
//  D2 <-> 3 - QC
//  D3 <-> 3 - QD
//  D4 <-> 3 - QE
//  D5 <-> 3 - QF
//  D6 <-> 3 - QG
//  D7 <-> 3 - QH

// 10110111 B7 183
// 00001111 0000111 787 1927

void writeEEPROM(int address, byte data)
{
  shiftOut(SHIFT_SER, SHIFT_SRCLK, MSBFIRST, data);
  shiftOut(SHIFT_SER, SHIFT_SRCLK, LSBFIRST, address);
  shiftOut(SHIFT_SER, SHIFT_SRCLK, LSBFIRST, address >> 8 | 0x80);

  digitalWrite(SHIFT_RCLK, LOW);
  delay(1);
  digitalWrite(SHIFT_RCLK, HIGH);
  delay(1);
  digitalWrite(SHIFT_RCLK, LOW);
  delay(1);

  digitalWrite(ROM_WE_B, LOW);
  delayMicroseconds(1);
  digitalWrite(ROM_WE_B, HIGH);
  delay(5);
}

void stepClock()
{
  digitalWrite(CPU_CLK, HIGH);
  delay(50);
  digitalWrite(CPU_CLK, LOW);
  delay(50);
}

void reset()
{
  digitalWrite(CPU_RES_B, LOW);
  delay(50);
  digitalWrite(CPU_RES_B, HIGH);
  delay(50);
}

void cpuMaster()
{
  digitalWrite(CPU_RES_B, HIGH);
  digitalWrite(CPU_BE, HIGH);

  digitalWrite(ROM_WE_B, HIGH);
  digitalWrite(ROM_OE_B, LOW);

  digitalWrite(SHIFT_OE_B, HIGH);
}

void shiftRegistersMasterForWrite()
{
  digitalWrite(CPU_RES_B, LOW);
  digitalWrite(CPU_BE, LOW);

  digitalWrite(ROM_WE_B, HIGH);
  digitalWrite(ROM_OE_B, HIGH);

  digitalWrite(SHIFT_OE_B, LOW);
}

void shiftRegistersMasterForRead()
{
  digitalWrite(CPU_RES_B, LOW);
  digitalWrite(CPU_BE, LOW);

  digitalWrite(ROM_WE_B, HIGH);
  digitalWrite(ROM_OE_B, LOW);

  digitalWrite(SHIFT_OE_B, LOW);
}