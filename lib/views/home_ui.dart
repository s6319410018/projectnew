import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//////////////////////////////////////////////////
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class homeUI extends StatefulWidget {
  String? email;
  homeUI({Key? key, this.email}) : super(key: key);
  //const homeUI({super.key});

  @override
  State<homeUI> createState() => _homeUIState();
}

class _homeUIState extends State<homeUI> {
  Future<List<RealtimeData>> fetchRealtimeDataList() async {
    final String url = "http://192.168.32.1/project/api/getRealtime.php";

    Map<String, dynamic> postData = {
      "userEmail": widget.email,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data.isNotEmpty && data[0].isNotEmpty) {
          List<RealtimeData> realtimeDataList =
              List.from(data[0].map((json) => RealtimeData.fromJson(json)));
          return realtimeDataList;
        } else {
          print('Empty data received');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    return [];
  }

  /////////////////////////////////////////////http post timcontrol
  Future<List<RealtimeData>> Controltime() async {
    final String url = "http://192.168.32.1/project/api/updateControlTime.php";

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateFormat timeFormat = DateFormat('HH:mm:ss');

    if (dateTimeList?[0] != null && dateTimeList?[1] != null) {
      Map<String, dynamic> postData = {
        "userEmail": widget.email,
        "control_Date_On":
            dateFormat.format(dateTimeList?[0] ?? DateTime.now()),
        "control_Time_On":
            timeFormat.format(dateTimeList?[0] ?? DateTime.now()),
        "control_Date_OFF":
            dateFormat.format(dateTimeList?[1] ?? DateTime.now()),
        "control_Time_OFF":
            timeFormat.format(dateTimeList?[1] ?? DateTime.now())
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(postData),
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data == "1") {
            showWarningDialogSuccess(context, '           ทำรายการสำเร็จ');
          } else {
            print('Empty data received');
          }
        } else {
          print('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred: $e');
      }
    } else {
      showWarningDialog(context, "            กรุณาตั้งเวลา");
    }
    return [];
  }

  showWarningDialog(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(
                      strokeAlign: MediaQuery.of(context).size.width * 0.009,
                      color: Color.fromARGB(255, 0, 0, 0))),
              backgroundColor: Color.fromARGB(255, 233, 127, 127),
              title: Center(
                child: Text(
                  'คำเตือน',
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.1),
                ),
              ),
              content: Container(
                child: Text(
                  msg,
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              icon: Icon(Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.1),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'ตกลง',
                      style: GoogleFonts.kanit(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  showWarningDialogSuccess(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(
                      strokeAlign: MediaQuery.of(context).size.width * 0.009,
                      color: Color.fromARGB(255, 0, 0, 0))),
              backgroundColor: Color.fromARGB(255, 141, 244, 158),
              title: Center(
                child: Text(
                  'คำเตือน',
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.1),
                ),
              ),
              content: Card(
                color: const Color.fromARGB(0, 255, 255, 255),
                child: Text(
                  msg,
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              icon: Icon(FontAwesomeIcons.clock,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.1),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'ตกลง',
                      style: GoogleFonts.kanit(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////
  final Color navigationBarColor = Colors.white; //ตัวแปรเก็บค่าสีของแท็บบาร์
  late PageController pageController;
  String? selectedValue;
  int selectedIndex = 0;

  late List<RealtimeData> _realtimeDataList;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    _realtimeDataList = [];
    _fetchDataPeriodically();
  }

  // Periodically fetch data every 5 seconds (adjust as needed)
  void _fetchDataPeriodically() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      List<RealtimeData> newData = await fetchRealtimeDataList();
      setState(() {
        _realtimeDataList = newData;
      });
    });
  }

  ///////////////////////////////////////////ส่วนการทำงานของแท็บบาร์

  bool water_icon = false;
  bool ai_icon = false;
  //////////////////////////////////////////datatestตัวแปรเก็บค่าON-OFF
  List<DateTime>? dateTimeList;
  int Year_ON = 0, Month_ON = 0, DayON = 0;
  int Year_OFF = 0, Month_OFF = 0, DayOFF = 0;
  int HourON = 0, MiniteON = 0, MillisecON = 0;
  int HourOFF = 0, MiniteOFF = 0, MillisecOFF = 0;

  //////////////////

  showWarningDialogtimeronoffwater(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ContextAction) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                  strokeAlign: MediaQuery.of(context).size.width * 0.009,
                  color: Colors.white)),
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'ยืนยันการทำรายการ',
              style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.08),
            ),
          ),
          content: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5,
                      color: Color.fromARGB(255, 71, 233, 87),
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 71, 233, 87),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06),
                        child: Text(
                            "วันที่ $day_start  เวลา $on_minit_start นาฬิกา $on_minit_start นาที "),
                      ),
                    ],
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5,
                      color: Color.fromARGB(255, 233, 71, 71),
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 233, 71, 71),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06),
                        child: Text(
                            "วันที่ $day_stop  เวลา $off_minit_stop นาฟิกา $off_minit_stop นาที "),
                      ),
                    ],
                  )),
            ],
          ),
          icon: Icon(FontAwesomeIcons.clock,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.1),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.00,
                    bottom: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        '    OK    ',
                        style: GoogleFonts.kanit(
                            color: Color.fromARGB(255, 71, 233, 87),
                            fontSize: MediaQuery.of(context).size.width * 0.06),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'CLOSE',
                        style: GoogleFonts.kanit(
                            color: Color.fromARGB(221, 51, 44, 44),
                            fontSize: MediaQuery.of(context).size.width * 0.06),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  int on_hour_start = 0;
  int on_minit_start = 0;
  int off_hour_stop = 0;
  int off_minit_stop = 0;
  int day_start = 0;
  int day_stop = 0;
  int month_start = 0;
  int month_stop = 0;
  int year_start = 0;
  int year_stop = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF7BD5E5),
        appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.width * 0.2,
            backgroundColor: Color(0xFF7BD5E5),
            title: Text(
              'มาตรวัดน้ำอัจฉริยะ',
              style: GoogleFonts.kanit(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true),
        // backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            Container(
              //หน้าที่ 1
              color: Color(0xFF7BD5E5),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.045,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height * 0.008,
                              left: MediaQuery.of(context).size.height * 0.0146,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.white),

                                borderRadius:
                                    BorderRadius.circular(5), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.127,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.127,
                                        ),
                                        child: Text(
                                          'โหมดเอไอ',
                                          style: GoogleFonts.kanit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.002,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (true) {
                                                water_icon = true;
                                                print(water_icon);
                                              }
                                            },
                                            icon:
                                                Icon(FontAwesomeIcons.powerOff),
                                            label: Text(
                                              "On Ai",
                                              style: GoogleFonts.kanit(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.002,
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 122, 230, 133),
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.002,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (true) {}
                                            },
                                            icon: Icon(FontAwesomeIcons.close),
                                            label: Text(
                                              "Off Ai",
                                              style: GoogleFonts.kanit(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.002,
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 200, 127, 127),
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.139,
                                            child: Card(
                                              color: Color.fromARGB(
                                                  0, 123, 213, 229),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    style: BorderStyle.none,
                                                    color: Color.fromARGB(
                                                        0, 123, 213, 229),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.002,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: ListView.builder(
                                                itemCount:
                                                    _realtimeDataList.length,
                                                itemBuilder: (context, index) {
                                                  RealtimeData realtimeData =
                                                      _realtimeDataList[index];

                                                  if (realtimeData.realtimeAI ==
                                                      1) {
                                                    water_icon =
                                                        true; // Use assignment operator to set the value
                                                  } else {
                                                    water_icon = false;
                                                  }

                                                  return Center(
                                                    child: Icon(
                                                      water_icon
                                                          ? FontAwesomeIcons
                                                              .toggleOn
                                                          : FontAwesomeIcons
                                                              .toggleOff,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.003,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height * 0.008,
                              left: MediaQuery.of(context).size.height * 0.0146,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.white),

                                borderRadius:
                                    BorderRadius.circular(5), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.127,
                                        ),
                                        child: Text(
                                          'โหมดปกติ',
                                          style: GoogleFonts.kanit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.002,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (true) {
                                                water_icon = true;
                                                print(water_icon);
                                              }
                                            },
                                            icon:
                                                Icon(FontAwesomeIcons.powerOff),
                                            label: Text(
                                              "On",
                                              style: GoogleFonts.kanit(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.002,
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 122, 230, 133),
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.002,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (true) {}
                                            },
                                            icon: Icon(FontAwesomeIcons.close),
                                            label: Text(
                                              "Off",
                                              style: GoogleFonts.kanit(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.002,
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 200, 127, 127),
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.139,
                                            child: Card(
                                              color: Color.fromARGB(
                                                  0, 123, 213, 229),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  style: BorderStyle.none,
                                                  color: Color.fromARGB(
                                                      0, 123, 213, 229),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.002,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: ListView.builder(
                                                itemCount:
                                                    _realtimeDataList.length,
                                                itemBuilder: (context, index) {
                                                  RealtimeData realtimeData =
                                                      _realtimeDataList[index];

                                                  if (realtimeData
                                                          .realtimeSolenoid ==
                                                      1) {
                                                    water_icon =
                                                        true; // Use assignment operator to set the value
                                                  } else {
                                                    water_icon = false;
                                                  }

                                                  return Center(
                                                    child: Icon(
                                                      water_icon
                                                          ? FontAwesomeIcons
                                                              .toggleOn
                                                          : FontAwesomeIcons
                                                              .toggleOff,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.003,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height * 0.008,
                              left: MediaQuery.of(context).size.height * 0.0146,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.white),

                                borderRadius:
                                    BorderRadius.circular(5), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        child: Text(
                                          'อัตราการไหล',
                                          style: GoogleFonts.kanit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.417,
                                      child: Card(
                                        color: Color(0xFF7BD5E5),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: ListView.builder(
                                            itemCount: _realtimeDataList.length,
                                            itemBuilder: (context, index) {
                                              RealtimeData realtimeData =
                                                  _realtimeDataList[index];
                                              return Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.01,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Center(
                                                          child: PrettyGauge(
                                                            gaugeSize:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                            segments: [
                                                              GaugeSegment(
                                                                  'Critically Low',
                                                                  10,
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          249,
                                                                          133,
                                                                          129)),
                                                              GaugeSegment(
                                                                  'Low',
                                                                  20,
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          180,
                                                                          133)),
                                                              GaugeSegment(
                                                                  'Medium',
                                                                  20,
                                                                  Color(
                                                                      0xFFFDD871)),
                                                              GaugeSegment(
                                                                  'High',
                                                                  50,
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          146,
                                                                          202,
                                                                          104)),
                                                            ],
                                                            valueWidget: Text(
                                                              '${realtimeData.realtimeFlowrate}\n' +
                                                                  "L/M",
                                                              style: GoogleFonts.kanit(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            currentValue:
                                                                realtimeData
                                                                    .realtimeFlowrate, //ใสค่าตรงนี้
                                                            needleColor:
                                                                Colors.white,
                                                            showMarkers: false,
                                                          ),
                                                        ),
                                                        subtitle: Center(
                                                          child: Text(
                                                            '${realtimeData.realtimeFlowrate} L/M',
                                                            style: GoogleFonts.kanit(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height * 0.008,
                              left: MediaQuery.of(context).size.height * 0.0146,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.white),

                                borderRadius:
                                    BorderRadius.circular(5), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Color(0xFF7BD5E5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.137,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.137,
                                        ),
                                        child: Text(
                                          'ความดัน',
                                          style: GoogleFonts.kanit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.417,
                                      child: Card(
                                        color: Color(0xFF7BD5E5),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: ListView.builder(
                                            itemCount: _realtimeDataList.length,
                                            itemBuilder: (context, index) {
                                              RealtimeData realtimeData =
                                                  _realtimeDataList[index];
                                              return Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.01,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Center(
                                                          child: PrettyGauge(
                                                            minValue: 0,
                                                            maxValue: 520,
                                                            gaugeSize:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                            segments: [
                                                              GaugeSegment(
                                                                  'Critically Low',
                                                                  60,
                                                                  Color(
                                                                      0xFFFDD871)),
                                                              GaugeSegment(
                                                                  'Low',
                                                                  200,
                                                                  Color(
                                                                      0xFF92CA68)),
                                                              GaugeSegment(
                                                                  'Medium',
                                                                  200,
                                                                  Color(
                                                                      0xFF92CA68)),
                                                              GaugeSegment(
                                                                  'High',
                                                                  60,
                                                                  Color(
                                                                      0xFFF98581)),
                                                            ],
                                                            valueWidget: Text(
                                                              '${realtimeData.realtimePressure}\n' +
                                                                  "PSI",
                                                              style: GoogleFonts.kanit(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            currentValue:
                                                                realtimeData
                                                                    .realtimePressure, //ใสค่าตรงนี้
                                                            needleColor:
                                                                Colors.white,
                                                            showMarkers: false,
                                                          ),
                                                        ),
                                                        subtitle: Center(
                                                          child: Text(
                                                            '${realtimeData.realtimePressure} PSI',
                                                            style: GoogleFonts.kanit(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ),
            Container(
                //หน้าที่ 2
                color: Color(0xFF7BD5E5),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.038,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.015,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.0001,
                                  ),
                                  Card(
                                    color: Color.fromARGB(0, 123, 213, 229),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.005, //<-- SEE HERE
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.735,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.005),
                                              ),
                                              Card(
                                                color: Color.fromARGB(
                                                    255, 123, 213, 229),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.white,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.22,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                  ),
                                                  child: Text(
                                                    'การควบคุมด้วยเวลา',
                                                    style: GoogleFonts.kanit(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.005,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.015),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Card(
                                                          color:
                                                              Color(0xFF7BD5E5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    IconButton(
                                                                  color: Colors
                                                                      .white,
                                                                  focusColor:
                                                                      Colors
                                                                          .black,
                                                                  hoverColor:
                                                                      Colors
                                                                          .red,
                                                                  iconSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.25,
                                                                  onPressed:
                                                                      () async {
                                                                    dateTimeList =
                                                                        await showOmniDateTimeRangePicker(
                                                                      context:
                                                                          context,
                                                                      startInitialDate:
                                                                          DateTime
                                                                              .now(),
                                                                      startFirstDate: DateTime(
                                                                              1600)
                                                                          .subtract(
                                                                              const Duration(days: 3652)),
                                                                      startLastDate:
                                                                          DateTime.now()
                                                                              .add(
                                                                        const Duration(
                                                                            days:
                                                                                3652),
                                                                      ),
                                                                      endInitialDate:
                                                                          DateTime
                                                                              .now(),
                                                                      endFirstDate: DateTime(
                                                                              1600)
                                                                          .subtract(
                                                                              const Duration(days: 3652)),
                                                                      endLastDate:
                                                                          DateTime.now()
                                                                              .add(
                                                                        const Duration(
                                                                            days:
                                                                                3652),
                                                                      ),
                                                                      is24HourMode:
                                                                          true,
                                                                      isShowSeconds:
                                                                          false,
                                                                      minutesInterval:
                                                                          1,
                                                                      secondsInterval:
                                                                          1,
                                                                      isForce2Digits:
                                                                          true,
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              16)),
                                                                      constraints:
                                                                          const BoxConstraints(
                                                                        maxWidth:
                                                                            350,
                                                                        maxHeight:
                                                                            650,
                                                                      ),
                                                                      transitionBuilder: (context,
                                                                          anim1,
                                                                          anim2,
                                                                          child) {
                                                                        return FadeTransition(
                                                                          opacity:
                                                                              anim1.drive(
                                                                            Tween(
                                                                              begin: 0,
                                                                              end: 1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                      transitionDuration:
                                                                          const Duration(
                                                                              milliseconds: 200),
                                                                      barrierDismissible:
                                                                          true,
                                                                    );
                                                                  },
                                                                  icon: Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: MediaQuery.of(context).size.height *
                                                                            0.015),
                                                                    child: Icon(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        FontAwesomeIcons
                                                                            .clock),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.018),
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          0,
                                                                          123,
                                                                          213,
                                                                          229),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                      bottom: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.024,
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.024,
                                                                    ),
                                                                    child: Text(
                                                                      'คลิกรูปตั้งเวลา',
                                                                      style: GoogleFonts.kanit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              0.04,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.005,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Card(
                                                          color:
                                                              Color(0xFF7BD5E5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.008),
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          0,
                                                                          123,
                                                                          229,
                                                                          148),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.096,
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.096,
                                                                      top: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                      bottom: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                    ),
                                                                    child: Text(
                                                                      'สถาณะปัจจุบัน',
                                                                      style: GoogleFonts.kanit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              0.045,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.002,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.35,
                                                                  child: Card(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            0,
                                                                            229,
                                                                            149,
                                                                            123),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        style: BorderStyle
                                                                            .none,
                                                                        color: Color.fromARGB(
                                                                            0,
                                                                            123,
                                                                            213,
                                                                            229),
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.002,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount:
                                                                          _realtimeDataList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        RealtimeData
                                                                            realtimeData =
                                                                            _realtimeDataList[index];

                                                                        if (realtimeData.realtimeTime ==
                                                                            1) {
                                                                          water_icon =
                                                                              true; // Use assignment operator to set the value
                                                                        } else {
                                                                          water_icon =
                                                                              false;
                                                                        }

                                                                        return Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                                                                            child:
                                                                                Icon(
                                                                              water_icon ? FontAwesomeIcons.toggleOn : FontAwesomeIcons.toggleOff,
                                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                                              size: MediaQuery.of(context).size.width * 0.2,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.005,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                      ),
                                                      child: Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          color:
                                                              Color(0xFF7BD5E5),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.007,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.005,
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.005,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                ),
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          0,
                                                                          123,
                                                                          213,
                                                                          229),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                      bottom: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.005,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.32,
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.32,
                                                                    ),
                                                                    child: Text(
                                                                      'เวลาที่ตั้ง',
                                                                      style: GoogleFonts.kanit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              0.045,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.001,
                                                                    right: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.019,
                                                                    left: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.019,
                                                                  ),
                                                                  child: Card(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            194,
                                                                            134,
                                                                            229,
                                                                            123),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          style:
                                                                              BorderStyle.solid),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: MediaQuery.of(context).size.height *
                                                                            0.01,
                                                                        bottom: MediaQuery.of(context).size.height *
                                                                            0.01,
                                                                        left: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                        right: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        ' วันที่ ${dateTimeList?[0].day}  เวลา ${dateTimeList?[0].hour} นาฬิกา ${dateTimeList?[0].minute} นาที ปี ${dateTimeList?[0].year} ',
                                                                        style: GoogleFonts
                                                                            .kanit(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width * 0.03,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.01,
                                                                  ),
                                                                  child: Card(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            194,
                                                                            229,
                                                                            153,
                                                                            123),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          style:
                                                                              BorderStyle.solid),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: MediaQuery.of(context).size.height *
                                                                            0.01,
                                                                        bottom: MediaQuery.of(context).size.height *
                                                                            0.01,
                                                                        left: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                        right: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        ' วันที่ ${dateTimeList?[1].day}  เวลา ${dateTimeList?[1].hour} นาฬิกา ${dateTimeList?[1].minute} นาที ปี ${dateTimeList?[1].year} ',
                                                                        style: GoogleFonts
                                                                            .kanit(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width * 0.03,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ])
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.0),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Controltime();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.002),
                                                          backgroundColor:
                                                              Color.fromARGB(0,
                                                                  226, 206, 27),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.85,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                              topRight: Radius
                                                                  .circular(5),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "ยืนยันการตั้งเวลา",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01),
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.002),
                                                          backgroundColor:
                                                              Color.fromARGB(0,
                                                                  226, 206, 27),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.85,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                              topRight: Radius
                                                                  .circular(5),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "ยกเลิกการตั้งเวลา",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), ///////////////
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.034,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
                //หน้าที่ 3
                color: Color(0xF5E3F7FD),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.034,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.035,
                        ),
                        SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.72,
                            width: MediaQuery.of(context).size.width * 0.93,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 10, color: Colors.white54),

                              borderRadius:
                                  BorderRadius.circular(10), //<-- SEE HERE
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.034,
                                  ),
                                  Card(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 6, //<-- SEE HERE
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.005),
                                                child: Card(
                                                  color: Colors.black,
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: Text(
                                                        'สรุปข้อมูลการใช้น้ำ\n  รายวัน-รายเดือน',
                                                        style: GoogleFonts.kanit(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                            color:
                                                                Colors.amber)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), ///////////////
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.034,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
                //หน้าที่ 4
                color: Color(0xF5E3F7FD),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.034,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.035,
                        ),
                        SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.72,
                            width: MediaQuery.of(context).size.width * 0.93,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 10, color: Colors.white54),

                              borderRadius:
                                  BorderRadius.circular(10), //<-- SEE HERE
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.034,
                                  ),
                                  Card(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 6, //<-- SEE HERE
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                child: Card(
                                                  color: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: Text('ข้อมูลผู้ใช้',
                                                        style: GoogleFonts.kanit(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                            color:
                                                                Colors.amber)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), ///////////////
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.034,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          inactiveIconColor: Colors.black38,
          waterDropColor: Color(0xFF7BD5E5),
          iconSize: MediaQuery.of(context).size.width * 0.08,
          backgroundColor: navigationBarColor,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.water_drop_rounded,
              outlinedIcon: Icons.water_drop_outlined,
            ),
            BarItem(
                filledIcon: FontAwesomeIcons.solidClock,
                outlinedIcon: FontAwesomeIcons.clock),
            BarItem(
              filledIcon: FontAwesomeIcons.solidChartBar,
              outlinedIcon: FontAwesomeIcons.chartBar,
            ),
            BarItem(
              filledIcon: Icons.person,
              outlinedIcon: Icons.person_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class RealtimeData {
  final int realtimeSolenoid;
  final int realtimeAI;
  final int realtimeTime;
  final double realtimeFlowrate;
  final double realtimePressure;

  RealtimeData({
    required this.realtimeSolenoid,
    required this.realtimeAI,
    required this.realtimeTime,
    required this.realtimeFlowrate,
    required this.realtimePressure,
  });

  factory RealtimeData.fromJson(Map<String, dynamic> json) {
    return RealtimeData(
      realtimeSolenoid: json['realtime_Solenoid'],
      realtimeAI: json['realtime_AI'],
      realtimeTime: json['realtime_Time'],
      realtimeFlowrate: json['realtime_Flowrate'].toDouble(),
      realtimePressure: json['realtime_Pressure'].toDouble(),
    );
  }
}
