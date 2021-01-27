#include <M5StickC.h>
#include <SPI.h>
#include <Wire.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#define SEALEVELPRESSURE_HPA (1013.25)

Adafruit_BME280 bme;


void setup() {

  M5.begin();
  Wire.begin(0, 26);


  //Serial.println(F("ENV Unit(BME280) test..."));

  while (!bme.begin()) {

    Serial.println("Could not find a valid BMP280 sensor, check wiring!");

    M5.Lcd.println("Could not find a valid BMP280 sensor, check wiring!");

  }

  //M5.Lcd.println("ENV Unit test...");

}



void loop() {

  float tmp = bme.readTemperature();

  float hum = bme.readHumidity();

  float pressure = bme.readPressure();

  //Serial.printf("Temperatura: %2.2f*C  Humedad: %0.2f%%  Pressure: %0.2fPa\r\n", tmp, hum, pressure);
  Serial.print(hum);
  Serial.print(",");
  Serial.println(tmp);
  

  M5.Lcd.setCursor(0, 0);

  //    M5.Lcd.println("Temp: %2.1f", tmp);
  //  M5.Lcd.println("Humi: %2.0f%%", hum);
  // M5.Lcd.println("Pressure:%2.0fPa",pressure);

  getTempC();
  getPressureP();
  getHumidityR();
 

  delay(2000);

}

void getTempC() {
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.println(" ");
  //M5.Lcd.println("Temperature:");
  M5.Lcd.println(bme.readTemperature());
  M5.Lcd.println("    *C");
  M5.Lcd.println(" ");
}

void getPressureP() {
  M5.Lcd.setTextColor(GREEN, BLACK);
  M5.Lcd.setTextSize(2);
  //M5.Lcd.println("Pressure:");
  M5.Lcd.println(bme.readPressure());
  M5.Lcd.println("    Pa");
  M5.Lcd.println(" ");

}

void getHumidityR() {
  M5.Lcd.setTextColor(BLUE, BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.println(bme.readHumidity());
  M5.Lcd.println("     %");
  M5.Lcd.println(" ");
}

void getAltitude(){
   M5.Lcd.println(" ");
  //M5.Lcd.println("Altitude:");
  M5.Lcd.println(bme.readAltitude(SEALEVELPRESSURE_HPA));
  M5.Lcd.println(" m");

}
