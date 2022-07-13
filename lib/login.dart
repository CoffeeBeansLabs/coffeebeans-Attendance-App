import 'dart:convert';
import 'package:coffeebeansattendanceapp/screens/readqr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  String url = "http://10.0.2.2:8080/employee/save";

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('SignIn Page',)),
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title:
            Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),

          // ElevatedButton(onPressed: myFunction, child: Text("save data")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ScanScreen())).then((value) => myFunction());

              },
              child: Text('Read QR code')),
          // ElevatedButton(onPressed: signOutFromGoogle, child: Text("SignOut"))

        ],

      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('You are not signed in..'),
          SignInButton(
            Buttons.Google,
            text: 'Sign in with Gmail',
            onPressed: () {
              _handleSignIn();
            },
          ),

        ],
      );
    }
  }


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  // Future<http.Response> save() async {
  //   return http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'email': _currentUser.email,
  //       'name': _currentUser.displayName
  //     }),
  //   );
  //
  // }
  // void myFunction() async {
  //   var data = {};
  //   var response = await http.post(Uri.parse(url), headers:<String,String>{
  //     'Content-Type': 'application/json;charset=UTF-8'
  //
  //   },
  //    body:jsonEncode({
  //      'email':_currentUser.email,
  //      'name':_currentUser.displayName
  //    }),
  //
  //
  //   );
  //   if (response.statusCode == 200) {
  //     print(response);
  //   } else {
  //     print('A network error occurred');
  //   }
  // }

  void myFunction() {
    var data = {};
    http.post(Uri.parse("http://10.0.2.2:8080/employee/save"), headers:<String,String>{
      'Content-Type': 'application/json;charset=UTF-8'
    },
      body:jsonEncode({
        'email':_currentUser.email,
        'name':_currentUser.displayName
      }),
    ).then((response) => print(response.body)).catchError((error) => print(error));
  }
}





