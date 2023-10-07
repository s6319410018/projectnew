import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartwatermeter/views/home_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DatadetailsDataSourcePage1 extends DataGridSource {
  DatadetailsDataSourcePage1(this.alldata) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'statusai', value: e.resultAi),
              DataGridCell<dynamic>(
                  columnName: 'statussolenoid', value: e.resultSolenoid),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  List<Datadetails> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color(0x52FFFFFF), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x53FFFFFF)),
                  borderRadius: BorderRadius.all(Radius.circular(1))),
              color: Color.fromARGB(141, 255, 255, 255),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(3.5),
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.kanit(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ))));
        }).toList());
  }

  void updateDataGrid(List<Datadetails> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'statusai', value: e.resultAi),
              DataGridCell<dynamic>(
                  columnName: 'statussolenoid', value: e.resultSolenoid),
              DataGridCell<dynamic>(columnName: 'flowrate', value: e.flowRate),
              DataGridCell<dynamic>(columnName: 'Pressure', value: e.pressure),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}

class DatadetailsDataSourcePage2 extends DataGridSource {
  DatadetailsDataSourcePage2(this.alldata) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.resultTime),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  List<Datadetails> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color(0x52FFFFFF), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x52000000)),
                  borderRadius: BorderRadius.all(Radius.circular(1))),
              color: Color.fromARGB(141, 255, 255, 255),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(3.5),
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.kanit(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ))));
        }).toList());
  }

  void updateDataGrid(List<Datadetails> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(
                  columnName: 'timecontrol', value: e.resultTime),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}

class DatadetailsDataSourcePage3 extends DataGridSource {
  DatadetailsDataSourcePage3(this.alldata) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _DataGridRows = alldata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'wateruse', value: e.waterUse),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
  }

  List<Datadetails> alldata = [];
  List<DataGridRow> _DataGridRows = [];

  @override
  List<DataGridRow> get rows => _DataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color(0x52FFFFFF), //พื้นหลัง
        cells: row.getCells().map<Widget>((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x52000000)),
                  borderRadius: BorderRadius.all(Radius.circular(1))),
              color: Color.fromARGB(141, 255, 255, 255),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(3.5),
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.kanit(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ))));
        }).toList());
  }

  void updateDataGrid(List<Datadetails> data_update) {
    _DataGridRows = data_update
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<dynamic>(columnName: 'id', value: e.monthId),
              DataGridCell<dynamic>(columnName: 'wateruse', value: e.waterUse),
              DataGridCell<dynamic>(columnName: 'date', value: e.date),
              DataGridCell<dynamic>(columnName: 'time', value: e.time),
            ]))
        .toList();
    notifyListeners();
  }
}
