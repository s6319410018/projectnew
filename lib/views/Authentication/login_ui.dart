import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smartwatermeter/views/home_ui.dart';
import 'package:smartwatermeter/views/Authentication/register_ui.dart';

class login_UI extends StatefulWidget {
  const login_UI({super.key});

  @override
  State<login_UI> createState() => _login_UIState();
}

class _login_UIState extends State<login_UI> {
  showWarningDialog(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: BorderSide(
                  strokeAlign: MediaQuery.of(context).size.width * 0.009,
                  color: Colors.white)),
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
                  Navigator.pop(context);
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
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
            )
          ],
        );
      },
    );
  }
////////////////ฟังก์ชั่นโชวการแจ้งเตือน

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        email.text = _email ?? "";
        pass.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleRemeberme(value) {
    print("Handle Rember Me");
    _isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', email.text);
        prefs.setString('password', pass.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

///////////////ส่วนสำหรับดึงข้อมูลผู้ใช้ที่ทำการจำรหัสผ่าน
  ///
  Future<void> sign_in() async {
    final String url = "http://192.168.32.1/project/api/loginApi.php";

    Map<String, dynamic> postData = {
      "userPassword": pass.text,
      "userEmail": email.text,
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
        print(data);

        if (data == "1") {
          print('Successfully posted data');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => homeUI(email: email.text),
              ));
        } else {
          print('Failed to post data. Server response: $data');
          showWarningDialog(
              context, 'ระบบทำรายการไม่สำเร็จโปรดทำรายการอีกครั้ง');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showWarningDialog(context, 'ระบบทำรายการไม่สำเร็จโปรดทำรายการอีกครั้ง');
      }
    } catch (e) {
      print('An error occurred: $e');
      showWarningDialog(context, 'ระบบทำรายการไม่สำเร็จโปรดทำรายการอีกครั้ง');
    }
  }

  final fromKey = GlobalKey<FormState>(); //ตัวแปรสำหรับส่งค่าเพื่อนำไปล็อกอิน
  bool isShowpassword = false;
  bool _isChecked = false;

  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/water.png"), /////
              fit: BoxFit.cover,

              colorFilter: ColorFilter.linearToSrgbGamma(),
              filterQuality: FilterQuality.high,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/icon.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: Color(0xFF7BD5E5)),
                  Text('มาตรวัดน้ำอัจฉริยะ',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.09)),
                  Center(
                    child: Form(
                      key: fromKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: MediaQuery.of(context).size.width *
                                        0.09,
                                    right: MediaQuery.of(context).size.width *
                                        0.09),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Color.fromARGB(255, 0, 0, 0),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 0, 0, 0)), //<--
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        hintText:
                                            'กรุณาป้อนอีเมล เช่น 123@gmail.com',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70)),
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 220, 220, 220)),
                                        label: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.39,
                                          child: Row(
                                            children: [
                                              Icon(Icons.email_rounded),
                                              Text(
                                                '   กรุณาป้อนอีเมล',
                                                style: GoogleFonts.kanit(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        )),

                                    controller: email,

                                    validator: (value) {
                                      const pattern =
                                          r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                                      final regex = RegExp(pattern);
                                      if (value!.isEmpty) {
                                        return 'กรุณาป้อนอีเมลอีกครั้ง';
                                      } else if (!regex.hasMatch(value)) {
                                        return 'รูปแบบผิดพลาด';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.09,
                                    right: MediaQuery.of(context).size.width *
                                        0.09),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,

                                    cursorColor: Color.fromARGB(255, 0, 0, 0),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 0, 0, 0)), //<--
                                    obscureText: !isShowpassword,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (isShowpassword == true) {
                                                isShowpassword = false;
                                              } else {
                                                isShowpassword = true;
                                              }
                                            });
                                          },
                                          icon: isShowpassword == true
                                              ? Icon(
                                                  Icons.visibility,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                )
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                        ),
                                        hintText:
                                            'ป้อนรหัสผ่านต้องมากกว่า 6 ตัวอักษร',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70)),
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 220, 220, 220)),
                                        label: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Row(
                                            children: [
                                              Icon(Icons.lock),
                                              Text(
                                                '   กรุณาป้อนรหัสผ่าน',
                                                style: GoogleFonts.kanit(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        )),
                                    controller: pass,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'ป้อนรหัสผ่านอีกครั้ง';
                                      } else if (value.length < 6) {
                                        return 'รหัสต้องมากกว่า 6 ตัวอักษร';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.06),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        fillColor: MaterialStateProperty.all(
                                            Colors.blue),
                                        focusColor: Colors.yellow,
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 1.0, color: Colors.red)),
                                        checkColor: Colors.black,
                                        activeColor: Colors.deepOrange,
                                        hoverColor: Colors.white,
                                        value: _isChecked,
                                        onChanged: _handleRemeberme,
                                      ),
                                      Text(
                                        "จำการเข้าใช้งาน",
                                        style: GoogleFonts.kanit(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              ElevatedButton(
                                onPressed: () {
                                  bool pass = fromKey.currentState!.validate();
                                  if (pass) {
                                    sign_in();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(184, 19, 135, 197),
                                  textStyle: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01,
                                    left:
                                        MediaQuery.of(context).size.width * 0.2,
                                    right:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  child: Text('เข้าสู่ระบบ',
                                      style: GoogleFonts.kanit(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ยังไม่มีรหัสผ่าน',
                                    style: GoogleFonts.kanit(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => registerUI(),
                                          ));
                                    },
                                    child: Text(
                                      'สมัครสมาชิกตอนนี้',
                                      style: GoogleFonts.kanit(
                                          color: Colors.blue[400],
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ),
      ],
    );
  }
}
