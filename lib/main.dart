import 'package:flutter/material.dart';
import 'package:smartwatermeter/views/home_ui.dart';
import 'package:smartwatermeter/views/Authentication/login_ui.dart';
import 'package:smartwatermeter/views/Authentication/register_ui.dart';
import 'package:smartwatermeter/views/splash_ui.dart';
import 'package:smartwatermeter/views/test.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splashUI(),
  ));
}
