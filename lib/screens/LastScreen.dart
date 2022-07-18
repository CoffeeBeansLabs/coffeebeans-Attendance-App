import 'package:coffeebeansattendanceapp/login.dart';
import 'package:coffeebeansattendanceapp/screens/readqr.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:intl/intl.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class TimeDate extends StatefulWidget {
  @override
  _TimeDateState createState() => _TimeDateState();
}

class _TimeDateState extends State<TimeDate> {
  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();

    Future.delayed(const Duration(seconds: 3),() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScanScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {

    Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Builder(
          builder: (context) {
            return Center(child: Container(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(child: Text("congratulations "+ _currentUser.displayName+ "your attendance has been submitted",style: TextStyle(color: Colors.green),textAlign: TextAlign.center,)),
            )));
          }
        ),
      ],
    );


  }
}