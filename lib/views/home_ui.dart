import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
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

  bool water_icon = false;
  bool ai_icon = false;
  //////////////////////////////////////////datatestตัวแปรเก็บค่าON-OFF

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
