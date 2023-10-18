
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#define HOSTWRITE "smartwater.atwebpages.com/DataEsp/dbwrite.php"  // Enter HOST URL without "http://" and "/" at the end of URL
#define HOSTESPKEY "smartwater.atwebpages.com/DataEsp/dbread.php"  // Enter HOST URL without "http://" and "/" at the end of URL
String urlWRITE = "http://" + String(HOSTWRITE);
String urlESPKEY = "http://" + String(HOSTESPKEY);
HTTPClient httpWRITE, httpREAD, httpESPKEY;
WiFiClient client;

bool exitLoop = false;
//#define HOSTREAD "smartwater.atwebpages.com/DataEsp/dbread.php"  // Enter HOST URL without "http://" and "/" at the end of URL
/////////////////////////////////////////

#define WIFI_SSID "Test"          // WIFI SSID here
#define WIFI_PASSWORD "83448344"  // WIFI password here
/////////////////////////////////////////////จอ
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>
#define i2c_Address 0x3c
#define SCREEN_WIDTH 128  // OLED display width, in pixels
#define SCREEN_HEIGHT 64  // OLED display height, in pixels
#define OLED_RESET -1     //   QT-PY / XIAO
Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
int motion = D3, motionDisplay;
////////////////////////////////////////////////////////// ตัวแปรเก็บค่า MotionSenser
String Flowrate, TotalLite, Presure, postData, postESPKEY, payload;
String espkey = "1234567890";
//////////////////////////////////////////////////////////ตัวแปรเก็บค่า Hosting
String GET_control_Date_ON,
  GET_control_Time_ON,
  GET_control_Date_OFF,
  GET_control_Time_OFF,
  GET_control_Solenoid,
  GET_control_AI,
  GET_result_SDPLUS,
  GET_Lasttimedata_DAY,
  GET_Lasttimedata_MONTH,
  GET_result_SD,
  total1, total2, total3, total4, total5, total6, total7, total8, val;  //trim function
int sepIndex, val_int, val2_int;
//////////////////////////////////////////////////////////ตัวแปรเก็บค่า classify_data
float RateWater, LitesWater, TotalWater;
float D_RateWater, D_LitesWater, D_TotalWater;
float M_RateWater, M_LitesWater, M_TotalWater;
int senserFlow = D4;
int solenoid_control = D5;
volatile long pulse;
unsigned long lastTime;
//////////////////////////////////////////////////////////ตัวแปรเก็บค่า Flow Senser
float Presure_all;
float pressure;
String pressuretostring;
const int pressureSensorPin = A0;  // Analog input pin for pressure sensor
const float pressureMin = 0.00;    // Minimum pressure in psi
const float pressureMax = 500.0;   // Maximum pressure in psi
const float voltageMin = 0.00;     // Minimum voltage from the sensor in V
const float voltageMax = 5.0;
/////////////////////////////////////////////////////////ตัวแปรเก็บค่า Presure Senser
#include <time.h>
int timezone = 7;  // http://www.satit.up.ac.th/BBC07/AboutStudent/Document/Geo_Time/WorldTime/pdf/TimeZone.pdf  // total 24 zone  -12 <---- 0 ---->+12    Zone 7 is Thailand  แต่ละzoneห่างกัน 1 ชั่วโมง
int dst = 0;       //เวลาออมแสง (daylight saving time - DST) https://thiti.dev/blog/118/
String formatted_date;
String formatted_time;
int timecontrolstop;




/////////////////////////////////////////////////////////ตัวแปรเวลา
int ai_control;
int time_control;
int Solenoid;

ICACHE_RAM_ATTR void increase() {
  pulse++;
}
void project() {
  float analogValue = analogRead(pressureSensorPin);

  //float voltage = map(analogValue, 0, 1023, voltageMin * 1000, voltageMax * 1000) / 1000.0; // Convert to V
  float voltage = (analogValue / 1023.0) * (voltageMax - voltageMin) + voltageMin;
  pressure = abs(map(analogValue, 0, 1023, pressureMin * 1000, pressureMax * 1000) / 1000.0 - 86.14);  // Convert to positive PSI
  //pressure = abs(map(analogValue, 0, 1023, pressureMin * 1000, pressureMax * 1000) / 1000.0 );
  //เป็นค่าปกติสำหรับการใช้งาน pressure sensor ที่มีช่วงการวัดความดัน 0-500 psi โดยค่าแรงดัน 0.90 V และความดัน 89.93 psi คือผลลัพธ์ที่เกิดขึ้นเมื่อไม่มีแรงกระทำบน pressure sensor นั่นคือค่าแรงดันฐาน หรือค่าศูนย์ (zero pressure) ของ sensor นั้นๆ เมื่อไม่มีแรงกระทำจากของเหลวหรือแก๊สใด ๆ บน sensor
  pressuretostring = String(pressure);


  //RateWater = (2.663 * pulse / 1000 * 30);  //ลิตร/นาที
  RateWater = ((2.663 * pulse * 0.85) / 1000 * 30);  //ลิตร/นาที
  LitesWater = (2.663 * pulse / 1000);
  TotalWater += LitesWater;
  Presure_all = 0.00;
  /////ตัวแปรเก็บค่าไปเรือยๆ
  D_RateWater = (2.663 * pulse / 1000 * 30);
  D_LitesWater = (2.663 * pulse / 1000);
  D_TotalWater += D_LitesWater;
  ////ตัวแปรเก็บข้อมูลรายวันจะรีเซ็ตทุกวันเวลา 23.59.59 นาที
  M_RateWater = (2.663 * pulse / 1000 * 30);
  M_LitesWater = (2.663 * pulse / 1000);
  M_TotalWater += M_LitesWater;
  ////ตัวแปรเก็บข้อมูลรายเดือนจะรีเซ็ตทุกเดือนเวลา วันที่ 1 นาที
  if (millis() - lastTime > 2000) {
    pulse = 0;
    lastTime = millis();
  }
  ////สัญญาณพัลซ์จะรีเซ็ตทุกสองวินาที

  Serial.print("VINPUT = ");
  Serial.print(voltage);
  Serial.print(" V ");
  Serial.print("\t");

  Serial.print("Pressure = ");
  Serial.print(pressure);
  Serial.print(" psi ");
  Serial.print("\t");

  Serial.print("Flowrate = ");
  Serial.print(RateWater);
  Serial.print(" L/m ");
  Serial.print("\t");

  Serial.print("Total of Water =  ");
  Serial.print(TotalWater);
  Serial.println(" L");

  Serial.print("Flowrate to Day = ");
  Serial.print(D_RateWater);
  Serial.print(" L/m ");
  Serial.print("\t");

  Serial.print("Total to day =  ");
  Serial.print(D_TotalWater);
  Serial.println(" L");

  Serial.print("Flowrate to Month = ");
  Serial.print(M_RateWater);
  Serial.print(" L/m ");
  Serial.print("\t");

  Serial.print("Total to Month =  ");
  Serial.print(M_TotalWater);
  Serial.println(" L");
  pinMode(senserFlow, INPUT);


  attachInterrupt(digitalPinToInterrupt(senserFlow), increase, RISING);
  delay(10000);
}

void classify_data(void) {
  Serial.println(payload);

  // Find the position of the opening <center> tag
  int centerStart = payload.indexOf("<center>");

  // Find the position of the closing </center> tag
  int centerEnd = payload.indexOf("</center>");

  // Check if both tags were found
  if (centerStart != -1 && centerEnd != -1) {
    // Extract the data between the <center> and </center> tags
    payload = payload.substring(centerStart + 8, centerEnd);  // 8 is the length of <center>
  }

  payload.trim();  // Trim any remaining whitespace
  Serial.println("");
  Serial.print("payload = ");
  Serial.println(payload);

  sepIndex = payload.indexOf(',');

  GET_control_Date_ON = payload.substring(0, sepIndex);
  Serial.print("GET_control_Date_ON = ");
  Serial.println(GET_control_Date_ON);
  total1 = payload.substring(sepIndex + 1);

  sepIndex = total1.indexOf(',');
  GET_control_Time_ON = total1.substring(0, sepIndex);
  Serial.print("  GET_control_Time_ON = ");
  Serial.println(GET_control_Time_ON);

  total2 = total1.substring(sepIndex + 1);

  sepIndex = total2.indexOf(',');
  GET_control_Date_OFF = total2.substring(0, sepIndex);
  Serial.print(" GET_control_Date_OFF = ");
  Serial.println(GET_control_Date_OFF);

  total3 = total2.substring(sepIndex + 1);

  sepIndex = total3.indexOf(',');
  GET_control_Time_OFF = total3.substring(0, sepIndex);
  Serial.print("GET_control_Time_OFF = ");
  Serial.println(GET_control_Time_OFF);

  total4 = total3.substring(sepIndex + 1);

  sepIndex = total4.indexOf(',');
  GET_control_Solenoid = total4.substring(0, sepIndex);
  Serial.print("GET_control_Solenoid = ");
  Serial.println(GET_control_Solenoid);

  total5 = total4.substring(sepIndex + 1);

  sepIndex = total5.indexOf(',');
  GET_control_AI = total5.substring(0, sepIndex);
  Serial.print("GET_control_AI = ");
  Serial.println(GET_control_AI);

  total6 = total5.substring(sepIndex + 1);

  sepIndex = total6.indexOf(',');
  GET_result_SD = total6.substring(0, sepIndex);
  Serial.print("GET_result_SD = ");
  Serial.println(GET_result_SD);

  total7 = total6.substring(sepIndex + 1);

  sepIndex = total7.indexOf(',');
  GET_Lasttimedata_DAY = total7.substring(0, sepIndex);
  Serial.print("GET_Lasttimedata_DAY = ");
  Serial.println(GET_Lasttimedata_DAY);

  sepIndex = total7.indexOf(',');
  GET_Lasttimedata_MONTH = total7.substring(sepIndex + 1);
  Serial.print("GET_Lasttimedata_MONTH = ");
  Serial.println(GET_Lasttimedata_MONTH);
}
void connectionfirsttimedata() {
  postESPKEY = "espkey=" + espkey;

  String urlESPKEY = "http://" + String(HOSTESPKEY);
  HTTPClient httpESPKEY;
  WiFiClient client;


  httpESPKEY.begin(client, urlESPKEY);
  httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded");
  delay(10000);
  int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
  Serial.print(postESPKEY);
  delay(10000);



  if (httpCodeESPKEY == 200) {
    Serial.println("Values uploaded ESPKEY.");
    Serial.println(httpCodeESPKEY);
    String webpageE = httpESPKEY.getString();  // Get HTML webpage output and store it in a string
    Serial.println(webpageE + "\n");
    payload = webpageE;
    classify_data();
    D_TotalWater = GET_Lasttimedata_DAY.toFloat();
    M_TotalWater = GET_Lasttimedata_MONTH.toFloat();


    //int httpCodeREAD  = httpREAD.GET();
    /*if(httpCodeREAD>0){
        Serial.printf("[HTTP] GET... code: %d\n", httpCodeREAD);
         if(httpCodeREAD == HTTP_CODE_OK) 
            {                       
              payload = httpREAD.getString();            
              classify_data();
            }
          }else{
               Serial.printf("[HTTP] GET... failed, error: %s\n", httpREAD.errorToString(httpCodeREAD).c_str());
               
          }*/


    delay(10000);
  } else {
    // Serial.println(httpCodeWRITE);
    Serial.println(httpCodeESPKEY);
    Serial.println("Failed to upload values.\n");
    httpESPKEY.end();
  }
}
 void Display(){
            motionDisplay = digitalRead(motion);
              Serial.print("motionDisplay = "); 
              Serial.println(motionDisplay);
              if (motionDisplay == 1) { 
                display.display();
                display.setTextSize(1);
                display.setTextColor(SH110X_WHITE);
                display.setCursor(0, 0);
                display.println("    WATER STATUS");
                display.println();
                display.println("Flowrate   = " + String(RateWater) + " L/S");
                display.println();
                display.println("Totalwater = " + String(TotalWater) + " L");
                display.println();
                display.println("Pressure   = " + String(pressure) + "PSI");
                display.display();
                display.clearDisplay();
              } else if (motionDisplay == 0) {
                display.display();
                display.clearDisplay();
              }
          }


void setup() {

  Serial.begin(115200);
  delay(250);
  display.begin(i2c_Address, true);
  display.display();
  delay(2000);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0, 0);
  display.println("  SMART WATER METER");
  display.println();
  display.println();
  display.setTextSize(2);
  display.println("  PROJECT");
  display.setTextSize(2);
  display.println("");
  display.setTextSize(1);
  display.println("  ......By SAU...... ");
  display.display();
  delay(5000);
  display.clearDisplay();
  /////หน้าจอเปืด
  Serial.println("Communication Started\n");
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0, 0);
  display.println("Communication Started");
  display.display();
  display.println();

  pinMode(motion, INPUT);
  pinMode(solenoid_control, OUTPUT);
  digitalWrite(solenoid_control, HIGH);
  Serial.println("ตัดน้ำจนกว่าจะมีการเชื่อมต่อ");
  ////////ตัดการใช้น้ำเมื่อยังไมเชื่อมต่อ
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);  // Try to connect with Wi-Fi
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  delay(2000);
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.print("Connecting to");
  display.display();
  delay(2000);
  while (WiFi.status() != WL_CONNECTED) {
    display.setTextSize(1);
    display.setTextColor(SH110X_WHITE);
    display.print(".");
    display.display();
    Serial.print(".");
    delay(500);
  }
  configTime(timezone * 3600, dst, "pool.ntp.org", "time.nist.gov");  // ทำชั่วโมงเป็นวินาที timezone=7  7x3600=25,200วินาที
  Serial.println("\nWaiting for time");
  while (!time(nullptr)) {
    Serial.print(".");
    delay(1000);
  }
  Serial.print(".");


  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  delay(2000);
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.print(WIFI_SSID);
  display.display();
  delay(2000);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());  // Print local IP address
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.println();
  display.println();
  display.print("IP =");
  display.print(WiFi.localIP());
  display.display();
  delay(2000);
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.println();
  display.println();
  display.println("Connect Success");
  display.display();
  delay(2000);
  display.clearDisplay();
  display.clearDisplay();
  //////////////////////////////////////
  connectionfirsttimedata();


  /////////////////////
}

void loop() {




  //connectionfirsttimedata();
  //////////////////////////////////////////////////////////////////ส่วนของเวลา

  //////////////////////////////////////////////////////////////////เรียกใช้ฟังก์ชั่น

  project();
  time_t now = time(nullptr);
    struct tm* p_tm = localtime(&now);

    int thour = p_tm->tm_hour;
    Serial.print(thour < 10 ? "0" : "");
    Serial.print(thour);
    Serial.print("(hour) ");

    int tminute = p_tm->tm_min;
    Serial.print(tminute < 10 ? "0" : "");
    Serial.print(tminute);
    Serial.print("(minute) ");

    int tsec = p_tm->tm_sec;
    Serial.print(tsec < 10 ? "0" : "");
    Serial.print(tsec);
    Serial.print("(sec) ");

    int tdate = p_tm->tm_mday;
    Serial.print(tdate);
    Serial.print("(date) ");

    int tmonth = p_tm->tm_mon + 1;
    Serial.print(tmonth);
    Serial.print("(month) ");

    int tyear = p_tm->tm_year + 1900;
    Serial.print(tyear);
    Serial.print("(year) ");

    int tday_of_week = p_tm->tm_wday + 1;
    Serial.print(tday_of_week);
    Serial.print("(day of week) ");

    // 0,1,2,3,4,5,6 วันจันทร์ถึงเสาร์ตามลำดับ
    int tday_of_year = p_tm->tm_yday;
    Serial.print(tday_of_year);
    Serial.print("(day of year) ");

    int tdst = p_tm->tm_isdst;
    Serial.print(tdst);
    Serial.println("(daylight saving time - DST)");

    // Format date as "YYYY-MM-DD"
    formatted_date = String(tyear) + "-" + String(tmonth) + "-" + String(tdate);
    Serial.print(formatted_date);
    Serial.println("(formatted date)");

    // Format time as "HH:MM:SS"
    formatted_time = (thour < 10 ? "0" : "") + String(thour) + ":" + (tminute < 10 ? "0" : "") + String(tminute);
    Serial.print(formatted_time);
    Serial.println("(formatted time)");


      if (thour == 23 && tminute == 59 && tsec == 59) {
      D_TotalWater == 0.00;
      Serial.println("ค่ายังรายวันรีเซ็ตแล้ว");
    } else {
      Serial.println("ค่ายังรายวันยังไม่รีเซ็ต");
    }
    if (tdate == 1) {
      M_TotalWater == 0.00;
      Serial.println("ค่ายังรายเดือนรีเซ็ตแล้ว");
    } else {
      Serial.println("ค่ายังรายเดือนยังไม่รีเซ็ต");
    }


  Flowrate = String(RateWater);
  TotalLite = String(TotalWater);
  postData = "Flowrate=" + Flowrate + "&Pressure=" + pressure + "&Solenoid=" + Solenoid + "&Ai_Status=" + ai_control + "&Time_Status=" + time_control + "&espkey=" + espkey + "&D_TotalWater=" + D_TotalWater + "&M_TotalWater=" + M_TotalWater + "&timecontrolstop=" + timecontrolstop;


  httpWRITE.begin(client, urlWRITE);                                          // Connect to the host where the MySQL database is hosted using WiFiClient                                           // Connect to the host where the MySQL database is hosted using WiFiClient
  httpESPKEY.begin(client, urlESPKEY);                                        // Connect to the host where the MySQL database is hosted using WiFiClient
  httpWRITE.addHeader("Content-Type", "application/x-www-form-urlencoded");   // Specify content-type header
  httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded"); 
  
   // Specify content-type header
  int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
  Serial.print(postESPKEY);



  if (httpCodeESPKEY == 200) {
    Serial.println();
    Serial.println("Values uploaded ESPKEY.");
    Serial.print(httpCodeESPKEY);
    String webpageE = httpESPKEY.getString();
    payload = webpageE;
    classify_data();
    Serial.print(formatted_time);
    Serial.print(formatted_date);
//////////////////////////////////////////////////////////////////////////      

     if(GET_control_AI == "1"){
     ai_control = 1; 
     for(int n ;(GET_control_Date_ON == formatted_date) && (GET_control_Time_ON == formatted_time)&&(!exitLoop);n++){

              Display();
              digitalWrite(solenoid_control, LOW);
              Serial.println("ตั้งเวลาเปิดน้ำสำเร็จขณะโหมดเอไอทำงาน");
              timecontrolstop = 1;
              time_control = 1;
              Solenoid = 1;
              project();
              httpWRITE.begin(client, urlWRITE);                                         
              httpESPKEY.begin(client, urlESPKEY);                                        
              httpWRITE.addHeader("Content-Type", "application/x-www-form-urlencoded");   
              httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded"); 

              int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
              Serial.print(postESPKEY);
                       if (httpCodeESPKEY == 200) {//ดึงข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded ESPKEY.");
                        Serial.print(httpCodeESPKEY);
                        String webpageE = httpESPKEY.getString();
                        payload = webpageE;
                        classify_data();
                        if((pressuretostring < GET_result_SD)){
                        digitalWrite(solenoid_control,HIGH );
                        Serial.println("Ai กำลังปิดน้ำอัตโนมัติขณะตั้งเวลาเปิดน้ำโหมดเอไอ");
                        timecontrolstop = 0;
                        time_control = 0;
                        Solenoid = 0;
                        exitLoop=true;
                        }else if(((GET_control_Date_OFF == formatted_date) &&
                                  (GET_control_Time_OFF == formatted_time)) ||
                                  ((GET_control_Date_ON == "0000-00-00") &&
                                  (GET_control_Date_OFF == "0000-00-00") &&
                                  (GET_control_Time_ON == "00:00:00") &&
                                  (GET_control_Time_OFF == "00:00:00"))){
                        digitalWrite(solenoid_control,HIGH );
                        Serial.println("กำลังปิดน้ำอัตโนมัติขณะตั้งเวลาเปิดน้ำโหมดเอไอ");
                        timecontrolstop = 0;
                        time_control = 0;
                        Solenoid = 0;
                        exitLoop=true;            
                        }
                        }
              int httpCodeWRITE = httpWRITE.POST(postData);
              Serial.print(postData);
                      if (httpCodeWRITE == 200) {//อัปข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded successfully.");
                        Serial.print(httpCodeWRITE);
                        String webpageW = httpWRITE.getString();
                        Serial.println(webpageW + "\n");
                      } else {
                        Serial.println("Failed to upload values.\n");
                        httpWRITE.end();
                      }}

   

     if(GET_control_Solenoid=="1"){
          digitalWrite(solenoid_control,LOW );
          Serial.println("กำลังเปิดน้ำขณะโหมดเอไอทำงาน");
          Solenoid = 1;
         while((pressuretostring < GET_result_SD) && (!exitLoop)){ //เอไอทำงาน
              Display();
              digitalWrite(solenoid_control, HIGH);
              Serial.println("Ai กำลังปิดน้ำอัตโนมัติ");
              Solenoid = 0;
              project();
              httpWRITE.begin(client, urlWRITE);                                         
              httpESPKEY.begin(client, urlESPKEY);                                        
              httpWRITE.addHeader("Content-Type", "application/x-www-form-urlencoded");   
              httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded"); 

              int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
              Serial.print(postESPKEY);
                       if (httpCodeESPKEY == 200) {//ดึงข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded ESPKEY.");
                        Serial.print(httpCodeESPKEY);
                        String webpageE = httpESPKEY.getString();
                        payload = webpageE;
                        classify_data();
                        if((pressuretostring > GET_result_SD)){
                        digitalWrite(solenoid_control,LOW );
                        Serial.println("Ai กำลังเปิดน้ำอัตโนมัติ");
                        Solenoid = 1;
                        exitLoop=true;
                        }}
              int httpCodeWRITE = httpWRITE.POST(postData);
              Serial.print(postData);
                      if (httpCodeWRITE == 200) {//อัปข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded successfully.");
                        Serial.print(httpCodeWRITE);
                        String webpageW = httpWRITE.getString();
                        Serial.println(webpageW + "\n");
                      } else {
                        Serial.println("Failed to upload values.\n");
                        httpWRITE.end();
                      }}


     
     }else
          digitalWrite(solenoid_control,HIGH );
          Serial.println("กำลังปิดน้ำขณะโหมดเอไอทำงาน");
          Solenoid = 0;
         while((pressuretostring < GET_result_SD) && (!exitLoop)){ //เอไอทำงาน
              Display();
              digitalWrite(solenoid_control, HIGH);
              Serial.println("Ai กำลังปิดน้ำอัตโนมัติ");
              Solenoid = 0;
              project();
              httpWRITE.begin(client, urlWRITE);                                         
              httpESPKEY.begin(client, urlESPKEY);                                        
              httpWRITE.addHeader("Content-Type", "application/x-www-form-urlencoded");   
              httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded"); 

              int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
              Serial.print(postESPKEY);
                       if (httpCodeESPKEY == 200) {//ดึงข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded ESPKEY.");
                        Serial.print(httpCodeESPKEY);
                        String webpageE = httpESPKEY.getString();
                        payload = webpageE;
                        classify_data();
                        if((pressuretostring > GET_result_SD)){
                        digitalWrite(solenoid_control,LOW );
                        Serial.println("Ai กำลังเปิดน้ำอัตโนมัติ");
                        Solenoid = 1;
                        exitLoop=true;
                        }}
              int httpCodeWRITE = httpWRITE.POST(postData);
              Serial.print(postData);
                      if (httpCodeWRITE == 200) {//อัปข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded successfully.");
                        Serial.print(httpCodeWRITE);
                        String webpageW = httpWRITE.getString();
                        Serial.println(webpageW + "\n");
                      } else {
                        Serial.println("Failed to upload values.\n");
                        httpWRITE.end();
                      }}

       
     












}else{
    ai_control = 0 ;
       for(int n ;(GET_control_Date_ON == formatted_date) && (GET_control_Time_ON == formatted_time)&&(!exitLoop);n++){
              Display();
              digitalWrite(solenoid_control, LOW);
              Serial.println("ตั้งเวลาเปิดน้ำสำเร็จขณะโหมดเอไอไม่ทำงาน");
              timecontrolstop = 1;
              time_control = 1;
              Solenoid = 1;
              project();
              httpWRITE.begin(client, urlWRITE);                                         
              httpESPKEY.begin(client, urlESPKEY);                                        
              httpWRITE.addHeader("Content-Type", "application/x-www-form-urlencoded");   
              httpESPKEY.addHeader("Content-Type", "application/x-www-form-urlencoded"); 

              int httpCodeESPKEY = httpESPKEY.POST(postESPKEY);
              Serial.print(postESPKEY);
                       if (httpCodeESPKEY == 200) {//ดึงข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded ESPKEY.");
                        Serial.print(httpCodeESPKEY);
                        String webpageE = httpESPKEY.getString();
                        payload = webpageE;
                        classify_data();
                        if(((GET_control_Date_OFF == formatted_date) &&
                                  (GET_control_Time_OFF == formatted_time)) ||
                                  ((GET_control_Date_ON == "0000-00-00") &&
                                  (GET_control_Date_OFF == "0000-00-00") &&
                                  (GET_control_Time_ON == "00:00:00") &&
                                  (GET_control_Time_OFF == "00:00:00"))){
                           digitalWrite(solenoid_control,HIGH );
                        Serial.println("กำลังปิดน้ำอัตโนมัติขณะตั้งเวลาเปิดน้ำโหมดเอไอ");
                        timecontrolstop = 0;
                        time_control = 0;
                        Solenoid = 0;
                        exitLoop=true;      
                        }
                        }
              int httpCodeWRITE = httpWRITE.POST(postData);
              Serial.print(postData);
                      if (httpCodeWRITE == 200) {//อัปข้อมูลสำเร็จ
                        Serial.println();
                        Serial.println("Values uploaded successfully.");
                        Serial.print(httpCodeWRITE);
                        String webpageW = httpWRITE.getString();
                        Serial.println(webpageW + "\n");
                      } else {
                        Serial.println("Failed to upload values.\n");
                        httpWRITE.end();
                      }}

   

     if(GET_control_Solenoid=="1"){
          digitalWrite(solenoid_control,LOW );
          Serial.println("กำลังเปิดน้ำขณะโหมดเอไอไม่ทำงาน");
          Solenoid = 1;
     }else
          digitalWrite(solenoid_control,HIGH );
          Serial.println("กำลังปิดน้ำขณะโหมดเอไอไม่ทำงาน");
          Solenoid = 0;
}

/////////////////////////////////////////////////////////////////////////////
            int httpCodeWRITE = httpWRITE.POST(postData);
            Serial.print(postData);
                  if (httpCodeWRITE == 200) {
                    Serial.println();
                    Serial.println("Values uploaded successfully.");
                    Serial.print(httpCodeWRITE);
                    String webpageW = httpWRITE.getString();
                    Serial.println(webpageW + "\n");
                  } else {
                    Serial.println("Failed to upload values.\n");
                    httpWRITE.end();
                  }
 } else {
 Serial.println("Failed to upload values.\n");
httpESPKEY.end();     
 
delay(10000);
 Display();
          }}



         