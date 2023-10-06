import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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
  /////////////////////////////////////////////Function POST เพื่อดึงค่าเรียลไทม์ต่างๆ CALL API
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
          showWarningDialog(context, "มีบางอย่างผิดพลาด");
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showWarningDialog(context, "มีบางอย่างผิดพลาด: ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
      showWarningDialog(context, "มีบางอย่างผิดพลาด: $e");
    }

    return [];
  }

  Future<List<RealtimeData>> fetchRealtimeWaterUseList() async {
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
          List<RealtimeData> realtimeWaterUseList =
              List.from(data[0].map((json) => RealtimeData.fromJson(json)));
          return realtimeWaterUseList;
        } else {
          print('Empty data received');
          showWarningDialog(context, "มีบางอย่างผิดพลาด");
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showWarningDialog(context, "มีบางอย่างผิดพลาด: ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
      showWarningDialog(context, "มีบางอย่างผิดพลาด: $e");
    }

    return [];
  }

  Future<List<Datadetails>> fetchRealtimeALLDataList() async {
    final String url = "http://192.168.32.1//project/api/getdataALL.php";

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
          List<Datadetails> realtimeALLDataList =
              List.from(data[0].map((json) => Datadetails.fromJson(json)));
          return realtimeALLDataList;
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

  /////////////////////////////////////////////Function POST ค่าอับเดตไปยังฐานข้อมูลหน้าที่สอง CALL API
  Future<List<RealtimeData>> Control_time_ON() async {
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
          showWarningDialog(
              context, '          ทำรายการไม่สำเร็จ: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred: $e');
        showWarningDialog(context, '          ทำรายการไม่สำเร็จ: $e');
      }
    } else {
      showWarningDialog(context, "            กรุณาตั้งเวลา");
    }
    return [];
  }

  Future<List<RealtimeData>> Control_time_OFF() async {
    final String url = "http://192.168.32.1/project/api/updateControlTime.php";

    if (dateTimeList?[0] != null && dateTimeList?[1] != null) {
      Map<String, dynamic> postData = {
        "userEmail": widget.email,
        "control_Date_On": "0000-00-00",
        "control_Time_On": "00:00:00",
        "control_Date_OFF": "0000-00-00",
        "control_Time_OFF": "00:00:00",
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
          showWarningDialog(
              context, '          ทำรายการไม่สำเร็จ: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred: $e');
        showWarningDialog(context, '          ทำรายการไม่สำเร็จ: $e');
      }
    } else {
      showWarningDialog(context, "ทำรายการไม่สำเร็จโปรดทำรายการอีกครั้ง");
    }
    return [];
  }

  /////////////////////////////////////////////Function POST  อัปเดตค่าการทำง่านของเอไอ CALL API
  Future<List<RealtimeData>> Control_ai() async {
    final String url = "http://192.168.32.1/project/api/updateControlAi.php";

    Map<String, dynamic> postData = {
      "userEmail": widget.email,
      "control_Ai": ControlAi.toString(),
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
          showWarningDialog(context, '           ทำรายการไม่สำเร็จ');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showWarningDialog(
            context, '         ทำรายการไม่สำเร็จ : ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
      showWarningDialog(context, '         ทำรายการไม่สำเร็จ : $e');
    }

    return [];
  }

  Future<List<RealtimeData>> Controlai_solenoid() async {
    final String url =
        "http://192.168.32.1/project/api/updateControlSolenoid.php";

    Map<String, dynamic> postData = {
      "userEmail": widget.email,
      "control_Solenoid": ControlSolenoid.toString(),
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
          showWarningDialog(context, '           ทำรายการไม่สำเร็จ');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showWarningDialog(
            context, '         ทำรายการไม่สำเร็จ : ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
      showWarningDialog(context, '         ทำรายการไม่สำเร็จ : $e');
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
              content: Card(
                color: const Color.fromARGB(0, 255, 255, 255),
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

  ///////////////////////////////////////////ตัวแปรสำหรับเก็บค่าควบคุมอุปกรณ์
  int ControlAi = 0;
  int ControlSolenoid = 0;
  /////////////////////////////////////////////
  late List<RealtimeData> _realtimeDataList;
  late List<RealtimeData> _realtimeWaterUseList;
  late DatadetailsDataSource _datadetailsDataSource;

  ////////////////////////////////////////////////////ส่วนของการตกแต่งคอลัมตารางเก็บข้อมูล
  List<GridColumn> _columns = [
    GridColumn(
        columnName: 'id',
        label: Container(
            color: const Color.fromARGB(255, 243, 99, 99),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerRight,
            child: Text('ลำดับ', style: GoogleFonts.kanit(fontSize: 10)))),
    GridColumn(
        columnName: 'flowrate',
        label: Center(
            child: Text('FLOWRATE', style: GoogleFonts.kanit(fontSize: 10)))),
    GridColumn(
        columnName: 'Pressure',
        label: Center(
            child: Text('PRESSURE', style: GoogleFonts.kanit(fontSize: 10)))),
    GridColumn(
        columnName: 'date',
        label: Center(
            child: Text('DATE', style: GoogleFonts.kanit(fontSize: 10)))),
    GridColumn(
        columnName: 'time',
        label: Center(
            child: Text('TIME', style: GoogleFonts.kanit(fontSize: 10)))),
  ];

  /////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    _realtimeDataList = [];
    _fetchDataPeriodically();
    _datadetailsDataSource = DatadetailsDataSource([]);
  }

  // Periodically fetch data every 5 seconds (adjust as needed)
  void _fetchDataPeriodically() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      List<RealtimeData> newData = await fetchRealtimeDataList();
      List<Datadetails> employees = await fetchRealtimeALLDataList();
      _datadetailsDataSource.updateDataGrid(employees);
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
  //////////////////

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
                                                ControlAi = 1;
                                                Control_ai();
                                                print(
                                                    'resultAI' + '$ControlAi');
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
                                              if (true) {
                                                ControlAi = 0;
                                                Control_ai();
                                                print(
                                                    'resultAI' + '$ControlAi');
                                              }
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
                                                ControlSolenoid = 1;
                                                Controlai_solenoid();
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
                                              if (true) {
                                                ControlSolenoid = 0;
                                                Controlai_solenoid();
                                              }
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.0001,
                              ),
                              Card(
                                color: Color.fromARGB(0, 123, 213, 229),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: MediaQuery.of(context).size.width *
                                        0.005, //<-- SEE HERE
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.735,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                                                bottom: MediaQuery.of(context)
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
                                                    0.22,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              ),
                                              child: Text(
                                                'การควบคุมด้วยเวลา',
                                                style: GoogleFonts.kanit(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                                                      color: Color(0xFF7BD5E5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              focusColor:
                                                                  Colors.black,
                                                              hoverColor:
                                                                  Colors.red,
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
                                                                          const Duration(
                                                                              days: 3652)),
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
                                                                          const Duration(
                                                                              days: 3652)),
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
                                                                  borderRadius:
                                                                      const BorderRadius
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
                                                                  transitionBuilder:
                                                                      (context,
                                                                          anim1,
                                                                          anim2,
                                                                          child) {
                                                                    return FadeTransition(
                                                                      opacity: anim1
                                                                          .drive(
                                                                        Tween(
                                                                          begin:
                                                                              0,
                                                                          end:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                                  transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                  barrierDismissible:
                                                                      true,
                                                                );
                                                              },
                                                              icon: Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.015),
                                                                child: Icon(
                                                                    color: Color
                                                                        .fromARGB(
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
                                                                top: MediaQuery.of(
                                                                            context)
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
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.024,
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.024,
                                                                ),
                                                                child: Text(
                                                                  'คลิกรูปตั้งเวลา',
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.04,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
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
                                                      color: Color(0xFF7BD5E5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: MediaQuery.of(
                                                                            context)
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
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.096,
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.096,
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                ),
                                                                child: Text(
                                                                  'สถาณะปัจจุบัน',
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.045,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.002,
                                                            ),
                                                            child: Container(
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
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            0,
                                                                            123,
                                                                            213,
                                                                            229),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.002,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
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
                                                                        _realtimeDataList[
                                                                            index];

                                                                    if (realtimeData
                                                                            .realtimeTime ==
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
                                                                          water_icon
                                                                              ? FontAwesomeIcons.toggleOn
                                                                              : FontAwesomeIcons.toggleOff,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          size: MediaQuery.of(context).size.width *
                                                                              0.2,
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                  ),
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: Colors.white,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      color: Color(0xFF7BD5E5),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
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
                                                                    color: Color
                                                                        .fromARGB(
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
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.005,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.32,
                                                                ),
                                                                child: Text(
                                                                  'เวลาที่ตั้ง',
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.045,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.001,
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.019,
                                                                left: MediaQuery.of(
                                                                            context)
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
                                                                      style: BorderStyle
                                                                          .solid),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
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
                                                                    ' วันที่ ${dateTimeList?[0].day}  เวลา ${dateTimeList?[0].hour} นาฬิกา ${dateTimeList?[0].minute} นาที ปี ${dateTimeList?[0].year} ',
                                                                    style: GoogleFonts
                                                                        .kanit(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
                                                                    ),
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
                                                                      style: BorderStyle
                                                                          .solid),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
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
                                                                    ' วันที่ ${dateTimeList?[1].day}  เวลา ${dateTimeList?[1].hour} นาฬิกา ${dateTimeList?[1].minute} นาที ปี ${dateTimeList?[1].year} ',
                                                                    style: GoogleFonts
                                                                        .kanit(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.0),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Control_time_ON();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                          color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.002),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              0, 226, 206, 27),
                                                      fixedSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Control_time_OFF();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                          color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.002),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              0, 226, 206, 27),
                                                      fixedSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                              FontWeight.bold,
                                                          color: Colors.white),
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
                                width:
                                    MediaQuery.of(context).size.width * 0.034,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
                //หน้าที่ 3
                color: Color(0xFF7BD5E5),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.0001,
                              ),
                              Card(
                                color: Color.fromARGB(0, 123, 213, 229),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: MediaQuery.of(context).size.width *
                                        0.005, //<-- SEE HERE
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.735,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005),
                                          ),
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
                                                    0.25,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              ),
                                              child: Text(
                                                'สรุปข้อมูลการใช้น้ำ',
                                                style: GoogleFonts.kanit(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                            ),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                ),
                                                borderRadius:
                                                    BorderRadiusDirectional.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              color: Color(0xFF7BD5E5),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.139,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        0, 123, 213, 229),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      123,
                                                                      213,
                                                                      229),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.002,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          _realtimeDataList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        RealtimeData
                                                            realtimeData =
                                                            _realtimeDataList[
                                                                index];
                                                        if (realtimeData
                                                                .Product_Details_Day_Water_Use !=
                                                            null) {
                                                          return Column(
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.01,
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  NumberFormat("การใช้น้ำวันนี้ = " +
                                                                          "#,##0.00 " +
                                                                          'ลิตร')
                                                                      .format(realtimeData
                                                                          .Product_Details_Day_Water_Use),
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.05,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          Text(
                                                            "การใช้น้ำวันนี้ = ยังไม่มีข้อมูล",
                                                            style: GoogleFonts.kanit(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                            ),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                ),
                                                borderRadius:
                                                    BorderRadiusDirectional.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              color: Color(0xFF7BD5E5),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.139,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        0, 123, 213, 229),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      123,
                                                                      213,
                                                                      229),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.002,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          _realtimeDataList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        RealtimeData
                                                            realtimeData =
                                                            _realtimeDataList[
                                                                index];
                                                        if (realtimeData
                                                                .Product_Details_Day_Water_Use !=
                                                            null) {
                                                          return Column(
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.01,
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  NumberFormat("การใช้น้ำเดือนนี้ = " +
                                                                          "#,##0.00 " +
                                                                          'ลิตร')
                                                                      .format(realtimeData
                                                                          .Product_Details_Month_Water_Use),
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.05,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          Text(
                                                            "การใช้น้ำเดือนนี้ = ยังไม่มีข้อมูล",
                                                            style: GoogleFonts.kanit(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.018,
                                            ),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                ),
                                                borderRadius:
                                                    BorderRadiusDirectional.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              color: Color(0xFF7BD5E5),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.139,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        0, 123, 213, 229),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      123,
                                                                      213,
                                                                      229),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.002,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          _realtimeDataList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        RealtimeData
                                                            realtimeData =
                                                            _realtimeDataList[
                                                                index];
                                                        double unit = realtimeData
                                                                .Product_Details_Day_Water_Use /
                                                            1000;
                                                        if (realtimeData
                                                                .Product_Details_Month_Water_Use !=
                                                            null) {
                                                          if (unit <= 30) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            8.50),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  31 &&
                                                              unit <= 41) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            10.03),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  41 &&
                                                              unit <= 50) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            10.35),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  51 &&
                                                              unit <= 60) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            10.68),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  61 &&
                                                              unit <= 70) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            11.00),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  71 &&
                                                              unit <= 80) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            11.33),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  81 &&
                                                              unit <= 90) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            12.50),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  91 &&
                                                              unit <= 100) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            12.82),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  101 &&
                                                              unit <= 120) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            13.15),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  121 &&
                                                              unit <= 160) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            13.47),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (unit >=
                                                                  161 &&
                                                              unit <= 200) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            13.80),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    NumberFormat("ค่าน้ำเดือนนี้ ≈ " +
                                                                            "#,##0.00 " +
                                                                            'บาท')
                                                                        .format(realtimeData.Product_Details_Month_Water_Use *
                                                                            14.45),
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        } else {
                                                          Text(
                                                            "ค่าน้ำเดือนนี้ ≈  ยังไม่มีข้อมูล",
                                                            style: GoogleFonts.kanit(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                              ),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          style:
                                                              BorderStyle.solid,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.005),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  color: Colors.blue,
                                                  child: SfDataGrid(
                                                    source:
                                                        _datadetailsDataSource,
                                                    columnWidthMode:
                                                        ColumnWidthMode.fill,
                                                    columns: _columns,
                                                  ),
                                                ),
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
                                    ), ///////////////
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.034,
                              ),
                            ],
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
  final String user_Name;
  final String user_Address;
  final String user_Email;
  final int user_Product_ID;
  final double Product_Details_Month_Water_Use;
  final double Product_Details_Day_Water_Use;

  RealtimeData({
    required this.realtimeSolenoid,
    required this.realtimeAI,
    required this.realtimeTime,
    required this.realtimeFlowrate,
    required this.realtimePressure,
    required this.user_Name,
    required this.user_Address,
    required this.user_Email,
    required this.user_Product_ID,
    required this.Product_Details_Month_Water_Use,
    required this.Product_Details_Day_Water_Use,
  });

  factory RealtimeData.fromJson(Map<String, dynamic> json) {
    return RealtimeData(
      realtimeSolenoid: json['realtime_Solenoid'],
      realtimeAI: json['realtime_AI'],
      realtimeTime: json['realtime_Time'],
      realtimeFlowrate: json['realtime_Flowrate'].toDouble(),
      realtimePressure: json['realtime_Pressure'].toDouble(),
      user_Name: json['user_Name'],
      user_Address: json['user_Address'],
      user_Email: json['user_Email'],
      user_Product_ID: json['user_Product_ID'],
      Product_Details_Month_Water_Use:
          json['Product_Details_Month_Water_Use'].toDouble(),
      Product_Details_Day_Water_Use:
          json['Product_Details_Day_Water_Use'].toDouble(),
    );
  }
}

class Datadetails {
  int monthId;
  int flowRate;
  int pressure;
  int waterUse;
  int resultSolenoid;
  int resultTime;
  int resultAi;
  String date;
  String time;
  int productKey;

  Datadetails({
    required this.monthId,
    required this.flowRate,
    required this.pressure,
    required this.waterUse,
    required this.resultSolenoid,
    required this.resultTime,
    required this.resultAi,
    required this.date,
    required this.time,
    required this.productKey,
  });

  factory Datadetails.fromJson(Map<String, dynamic> json) {
    return Datadetails(
      monthId: json['Product_Details_Month_Id'],
      flowRate: json['Product_Details_Month_Flowrate'],
      pressure: json['Product_Details_Month_Pressure'],
      waterUse: json['Product_Details_Month_Water_Use'],
      resultSolenoid: json['Product_Details_Result_Solenoid'],
      resultTime: json['Product_Details_Result_Time'],
      resultAi: json['Product_Details_Result_Ai'],
      date: json['date'],
      time: json['time'],
      productKey: json['product_key'],
    );
  }
}

class DatadetailsDataSource extends DataGridSource {
  DatadetailsDataSource(this.alldata) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _employeeDataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  List<Datadetails> alldata = [];
  List<DataGridRow> _employeeDataGridRows = [];

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: const Color.fromARGB(255, 255, 255, 255),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            color: const Color.fromARGB(92, 255, 214, 64),
            alignment: Alignment.center,
            child: Text(e.value.toString(),
                style: GoogleFonts.kanit(fontSize: 13)),
          );
        }).toList());
  }

  void updateDataGrid(List<Datadetails> newData) {
    _employeeDataGridRows = newData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}
