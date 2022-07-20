import 'package:coffeebeansattendanceapp/main.dart';
import 'package:coffeebeansattendanceapp/screens/login.dart';
import 'package:coffeebeansattendanceapp/screens/ScanScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';


class LastScreen extends StatefulWidget {
  @override
  LastScreenState createState() => LastScreenState();
}

class LastScreenState extends State<LastScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 3),() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInDemo()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (context) {
            return Center(child: Container(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(child: Text("congratulations your attendance has been submitted",style: TextStyle(color: Colors.white),textAlign: TextAlign.center)),
            )));
          }
        ),
      ],
    );


  }
}