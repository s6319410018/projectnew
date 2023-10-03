import 'dart:convert';
import 'dart:async'; // Import the async package for Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

Future<List<RealtimeData>> fetchRealtimeDataList() async {
  final String url = "http://192.168.32.1/project/api/getRealtime.php";

  Map<String, dynamic> postData = {
    "userEmail": "ekwongsap@gmail.com",
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Realtime Data List'),
        ),
        body: RealtimeDataListWidget(),
      ),
    );
  }
}

class RealtimeDataListWidget extends StatefulWidget {
  @override
  _RealtimeDataListWidgetState createState() => _RealtimeDataListWidgetState();
}

class _RealtimeDataListWidgetState extends State<RealtimeDataListWidget> {
  late List<RealtimeData> _realtimeDataList;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (_realtimeDataList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _realtimeDataList.length,
        itemBuilder: (context, index) {
          RealtimeData realtimeData = _realtimeDataList[index];
          return ListTile(
            title: Text('Solenoid: ${realtimeData.realtimeSolenoid}'),
            subtitle: Text('AI: ${realtimeData.realtimeAI}'),
          );
        },
      );
    }
  }
}
