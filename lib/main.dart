import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coffeebeansattendanceapp/login.dart';

void main() => runApp(MaterialApp(
  title: 'Google Sign in',
  home: Splash(),
));


class Splash extends StatefulWidget {
  @override
  _SplashState createState()=> _SplashState();
}
class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInDemo()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/coffeebeans.png',height: 130,),
            const SizedBox(height: 130,),
            if(Platform.isIOS)
              const CupertinoActivityIndicator(
                radius: 20,
              )
            else
              const CircularProgressIndicator(
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}


