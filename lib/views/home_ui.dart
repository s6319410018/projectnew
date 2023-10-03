import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

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
  bool ai_icon = false;
  bool water_icon = false;
  //////////////////////////////////////////datatestตัวแปรเก็บค่าON-OFF

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
              color: Color(0xF5E3F7FD),
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
                                color: Color(0xFF7BD5E5),
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.black),

                                borderRadius:
                                    BorderRadius.circular(10), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Text('AI MODE',
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06)),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (true) {
                                          ai_icon = true;
                                          print(ai_icon);
                                        }
                                      },
                                      icon: Icon(FontAwesomeIcons.powerOff),
                                      label: Text(
                                        "On Ai",
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
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
                                        backgroundColor:
                                            Color.fromARGB(255, 122, 230, 133),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                            MediaQuery.of(context).size.width *
                                                0.125),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (true) {
                                          ai_icon = false;
                                          print(ai_icon);
                                        }
                                      },
                                      icon: Icon(FontAwesomeIcons.close),
                                      label: Text(
                                        "Off AI",
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
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
                                        backgroundColor:
                                            Color.fromARGB(255, 200, 127, 127),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                            MediaQuery.of(context).size.width *
                                                0.125),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.14,
                                      child: Card(
                                        color: Colors.grey[500],
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Icon(
                                          ai_icon == true
                                              ? FontAwesomeIcons.toggleOn
                                              : FontAwesomeIcons.toggleOff,
                                          color: Color(0xFF7BD5E5),
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
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
                              left: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                color: Color(0xFF7BD5E5),
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.black),

                                borderRadius:
                                    BorderRadius.circular(10), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Text('Manul MODE',
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06)),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (true) {
                                          water_icon = true;
                                          print(water_icon);
                                        }
                                      },
                                      icon: Icon(FontAwesomeIcons.powerOff),
                                      label: Text(
                                        "On Water",
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
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
                                        backgroundColor:
                                            Color.fromARGB(255, 122, 230, 133),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                            MediaQuery.of(context).size.width *
                                                0.125),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (true) {
                                          water_icon = false;
                                          print(water_icon);
                                        }
                                      },
                                      icon: Icon(FontAwesomeIcons.close),
                                      label: Text(
                                        "Off Water",
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
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
                                        backgroundColor:
                                            Color.fromARGB(255, 200, 127, 127),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                            MediaQuery.of(context).size.width *
                                                0.125),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.14,
                                      child: Card(
                                        color: Colors.grey[500],
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Icon(
                                          water_icon == true
                                              ? FontAwesomeIcons.toggleOn
                                              : FontAwesomeIcons.toggleOff,
                                          color: Color(0xFF7BD5E5),
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                      ),
                                    )
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
                                color: Color(0xFF7BD5E5),
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.black),

                                borderRadius:
                                    BorderRadius.circular(10), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Text('Flowrate',
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06)),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.423,
                                      child: Card(
                                        color: Colors.grey[500],
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: ListView.builder(
                                            itemCount: _realtimeDataList.length,
                                            itemBuilder: (context, index) {
                                              RealtimeData realtimeData =
                                                  _realtimeDataList[index];
                                              return ListTile(
                                                title: Text(
                                                    'Solenoid: ${realtimeData.realtimeSolenoid}'),
                                                subtitle: Text(
                                                    'AI: ${realtimeData.realtimeAI}'),
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
                              left: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.314,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                color: Color(0xFF7BD5E5),
                                border: Border.all(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                    color: Colors.black),

                                borderRadius:
                                    BorderRadius.circular(10), //<-- SEE HERE
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Text('Pressure',
                                        style: GoogleFonts.kanit(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06)),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.424,
                                      child: Card(
                                        color: Colors.grey[500],
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
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
                color: Color(0xF5E3F7FD),
                child: Stack(
                  children: [
                    Padding(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.72,
                                width: MediaQuery.of(context).size.width * 0.93,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 10, color: Colors.white54),

                                  borderRadius:
                                      BorderRadius.circular(10), //<-- SEE HERE
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                      ),
                                      Card(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            width: 6, //<-- SEE HERE
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                        right:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.005),
                                                  ),
                                                  Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.26,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.26,
                                                      ),
                                                      child: Text(
                                                        'ควบคุมการไหล',
                                                        style: GoogleFonts.kanit(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    color: Colors.amber,
                                                  )
                                                ],
                                              ),
                                            ), ///////////////
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
