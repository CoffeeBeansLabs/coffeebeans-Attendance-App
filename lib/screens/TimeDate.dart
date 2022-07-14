import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeDate extends StatefulWidget {
  @override
  _TimeDateState createState() => _TimeDateState();
}

class _TimeDateState extends State<TimeDate> {

  String _timeString;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime =
    DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
      print(_timeString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Display Current DateTime')),
        ),
        body: Center(
          child:
              Column(
                children: [
                  Text(
                    _timeString.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Body Temperature',
                    ),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Submit')),

                ],
              )
        ),
      ),
    );
  }
}