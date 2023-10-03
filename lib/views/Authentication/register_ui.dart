import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartwatermeter/views/home_ui.dart';
import 'package:http/http.dart' as http;
import 'package:smartwatermeter/views/Authentication/login_ui.dart';

class registerUI extends StatefulWidget {
  const registerUI({super.key});

  @override
  State<registerUI> createState() => _registerUIState();
}

class _registerUIState extends State<registerUI> {
  @override
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

  showWarningDialogsuccess(BuildContext context, String emailhome) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: BorderSide(
                  strokeAlign: MediaQuery.of(context).size.width * 0.009,
                  color: Color.fromARGB(255, 0, 0, 0))),
          backgroundColor: Colors.blue[100],
          title: Center(
            child: Text(
              'สมัครสมาชิกสำเร็จ',
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.09,
              ),
            ),
          ),
          content: Container(
            child: Text(
              'กดปุ่ม ตกลง เพื่อเข้าสูระบบ\nหรือกดปุ่ม ยกเลิก เพื่อทำรายการอีกครั้ง',
              style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
          icon: Icon(Icons.water_drop_rounded,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.1),
          actions: [
            Center(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => homeUI(email: emailhome),
                          ),
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
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
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
                      backgroundColor: Color.fromARGB(255, 254, 105, 105),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'ยกเลิก',
                      style: GoogleFonts.kanit(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  final fromKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController key = TextEditingController();
  bool isShowpassword = false;
  bool isShowpasswordre = false;

  Future<void> sign_up() async {
    final String url = "http://192.168.32.1/project/api/registerApi.php";

    Map<String, dynamic> postData = {
      "userName": name.text,
      "userAddress": address.text,
      "userPhone": phone.text,
      "userPassword": pass.text,
      "userProductId": key.text,
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

        if (data == "1") {
          print('Successfully posted data');
          String emailhome = email.text;
          showWarningDialogsuccess(context, emailhome);
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

  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_register_bg.jpg"), /////
          fit: BoxFit.cover,

          colorFilter: ColorFilter.linearToSrgbGamma(),
          filterQuality: FilterQuality.high,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Form(
              key: fromKey,
              child: ListView(
                physics: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.001,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                                left: MediaQuery.of(context).size.width * 0.06,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => login_UI(),
                                      ));
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: MediaQuery.of(context).size.width *
                                        0.08,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/images/icon.png',
                          width: MediaQuery.of(context).size.width * 0.35,
                          color: Color(0xFF7BD5E5)),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ), //<--
                            obscureText: false,

                            decoration: InputDecoration(
                                hintText: 'ชื่อ-นามสกุล',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Row(
                                    children: [
                                      Icon(Icons.people_rounded),
                                      Text(
                                        '   กรุณาป้อนชื่อ',
                                        style: GoogleFonts.kanit(
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            controller: name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ป้อนชื่อก่อนทำรายการอีกครั้ง';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: 'ที่อยู่ปัจจุบัน',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  child: Row(
                                    children: [
                                      Icon(Icons.home_work_rounded),
                                      Text(
                                        '   กรุณาป้อนที่อยู่',
                                        style: GoogleFonts.kanit(
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            controller: address,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ป้อนที่อยู่ก่อนทำรายการอีกครั้ง';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: 'เบอร์โทรศัพย์ 10 ตัว',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_android_rounded),
                                      Text(
                                        '   กรุณาป้อนเบอร์โทร',
                                        style: GoogleFonts.kanit(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )),
                            controller: phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ป้อนเบอร์ก่อนทำรายการอีกครั้ง';
                              } else if (value.length < 10) {
                                return 'เบอร์ไม่ถึง 10 ตัว';
                              } else if (value.length > 10) {
                                return 'เบอร์เกิน 10 ตัว';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: 'กรุณาป้อนอีเมล เช่น 123@gmail.com',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.39,
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
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
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
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                ),
                                hintText: 'ป้อนรหัสผ่านต้องมากกว่า 6 ตัวอักษร',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
                            obscureText: !isShowpasswordre,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isShowpasswordre == true) {
                                        isShowpasswordre = false;
                                      } else {
                                        isShowpasswordre = true;
                                      }
                                    });
                                  },
                                  icon: isShowpasswordre == true
                                      ? Icon(
                                          Icons.visibility,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                ),
                                hintText: 'รหัสผ่านต้องตรงกัน',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.59,
                                  child: Row(
                                    children: [
                                      Icon(Icons.lock),
                                      Text(
                                        '   กรุณายืนยันรหัสผ่านอีกครั้ง',
                                        style: GoogleFonts.kanit(
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),

                            validator: (value) {
                              if (value != pass.text) {
                                return 'รหัสผ่านไม่ตรงกัน';
                              } else if (value!.isEmpty) {
                                return 'ป้อนรหัสผ่านก่อน';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09,
                            right: MediaQuery.of(context).size.width * 0.09,
                            bottom: MediaQuery.of(context).size.width * 0.03),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)), //<--
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: 'คีย์อยู่ในอุปกรณ์',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 220, 220, 220)),
                                label: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Row(
                                    children: [
                                      Icon(Icons.password_rounded),
                                      Text(
                                        '   กรุณาป้อนคีย์',
                                        style: GoogleFonts.kanit(
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            controller: key,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ป้อนคีย์ก่อนทำรายการอีกครั้ง';
                              } else if (value.length < 10) {
                                return 'เบอร์ไม่ถึง 10 ตัว';
                              } else if (value.length > 10) {
                                return 'เบอร์เกิน 10 ตัว';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bool pass = fromKey.currentState!.validate();
                          if (pass) {
                            sign_up();
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
                            bottom: MediaQuery.of(context).size.height * 0.01,
                            top: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.width * 0.03,
                            left: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Text(
                            'ลงทะเบียนการใช้งาน',
                            style:
                                GoogleFonts.kanit(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
