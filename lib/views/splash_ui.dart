import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smartwatermeter/views/home_ui.dart';
import 'package:smartwatermeter/views/Authentication/login_ui.dart';

class splashUI extends StatefulWidget {
  const splashUI({super.key});

  @override
  State<splashUI> createState() => _splashUIState();
}

class _splashUIState extends State<splashUI> {
  @override
  String _email1 = '';
  String _password1 = '';

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _email1 = _prefs.getString("email") ?? "";
      _password1 = _prefs.getString("password") ?? "";
      print(_email1);
      print(_password1);
    } catch (e) {
      print(e);
    }
  }

  Future<void> sign_in() async {
    final String url =
        "http://smartwater.atwebpages.com/appdata/TESTAPI/project/api/loginApi.php";

    Map<String, dynamic> postData = {
      "userPassword": _password1,
      "userEmail": _email1
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
                builder: (context) => homeUI(email: _email1),
              ));
        } else {
          print('Failed to post data. Server response: $data');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => login_UI(),
              ));
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => login_UI(),
            ));
      }
    } catch (e) {
      print('An error occurred: $e');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => login_UI(),
          ));
    }
  }

  void initState() {
    //ทำหน้านี้ให้เป็น SplashScreen
    _loadUserEmailPassword();

    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      if (_email1 == 'null') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => login_UI(),
          ),
        );
      } else {
        sign_in();
      }
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_register_bg.jpg"), /////
                fit: BoxFit.cover,

                colorFilter: ColorFilter.linearToSrgbGamma(),
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.15,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Image.asset(
              'assets/images/icon.png',
              width: MediaQuery.of(context).size.width * 0.9,
              color: Color(0xFF85E8F7),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'มาตรวัดน้ำอัจฉริยะ',
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Text(
                      'จัดทำขึ้นเพื่อทดสอบโปรเจค',
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: CircularProgressIndicator(
                  semanticsLabel: AutofillHints.addressCity,
                  backgroundColor: Colors.transparent,
                  color: Colors.black38,
                  strokeWidth: MediaQuery.of(context).size.width * 0.02,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
