import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Employee {
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

  Employee({
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

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
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

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.employees) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _employeeDataGridRows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'aicontrol', value: e.resultAi),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.resultTime),
              DataGridCell<dynamic>(
                  columnName: 'solenoidcontrol', value: e.resultSolenoid),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  List<Employee> employees = [];
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
            child: Text(e.value.toString(), style: GoogleFonts.kanit()),
          );
        }).toList());
  }

  void updateDataGrid(List<Employee> newData) {
    _employeeDataGridRows = newData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'aicontrol', value: e.resultAi),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.resultTime),
              DataGridCell<dynamic>(
                  columnName: 'solenoidcontrol', value: e.resultSolenoid),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}

class SingleUi extends StatefulWidget {
  const SingleUi({Key? key}) : super(key: key);

  @override
  State<SingleUi> createState() => _SingleUiState();
}

class _SingleUiState extends State<SingleUi> {
  late EmployeeDataSource employeeDataSource; // Declare the data source

  @override
  void initState() {
    super.initState();
    employeeDataSource = EmployeeDataSource([]);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Employee> employees = await fetchRealtimeDataList();
      employeeDataSource.updateDataGrid(employees);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<Employee>> fetchRealtimeDataList() async {
    final String url = "http://192.168.32.1//project/api/getdataALL.php";

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
          List<Employee> realtimeDataList =
              List.from(data[0].map((json) => Employee.fromJson(json)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion flutter datagrid'),
      ),
      body: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: MediaQuery.of(context).size.width * 0.005),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          color: Colors.blue,
          child: SfDataGrid(
            columnSizer: ColumnSizer(),
            source: employeeDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            columns: _columns,
          ),
        ),
      ),
    );
  }
}

List<GridColumn> _columns = [
  GridColumn(
      columnName: 'id',
      label: Container(
          color: const Color.fromARGB(255, 243, 99, 99),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.centerRight,
          child: Text('ลำดับ', style: GoogleFonts.kanit(fontSize: 10)))),
  GridColumn(
      columnName: 'aicontrol',
      label: Center(child: Text('AI', style: GoogleFonts.kanit(fontSize: 10)))),
  GridColumn(
      columnName: 'timecontrol',
      label: Center(
          child: Text('TIMESET', style: GoogleFonts.kanit(fontSize: 10)))),
  GridColumn(
      columnName: 'solenoidcontrol',
      label: Center(
          child: Text('STATUS', style: GoogleFonts.kanit(fontSize: 10)))),
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
      label:
          Center(child: Text('DATE', style: GoogleFonts.kanit(fontSize: 10)))),
  GridColumn(
      columnName: 'time',
      label:
          Center(child: Text('TIME', style: GoogleFonts.kanit(fontSize: 10)))),
];
