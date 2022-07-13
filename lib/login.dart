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
  String url = "http://localhost:8080/employee/save";
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
        children:  <Widget> [
          ListTile (
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title:
            Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CreateScreen()));
          //       print('creating qr code');
          //     },
          //     child: Text('create QR code')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ScanScreen()));
                print('Read qr code');
              },
              child: Text('Read QR code')),

        ],
      );
    }
    else{
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


  Future<void> _handleSignIn() async{
    try{
      await _googleSignIn.signIn();
      save();
    }catch(error){
      print(error);
    }
  }


  // Future<void> _handleSignOut() async{
  //   Navigator.push(context, MaterialPageRoute(builder:(context)=>ScanDemo()));
  // }

  Future<void> save() async {
    try {
      var response = await http.post(
          Uri.parse(url), headers: {'Context-Type': 'application/json'},
          body: json.encode(
              {
                _currentUser.email ?? '',
                _currentUser.displayName ?? '',
              }
          ));
      if (response.statusCode == 200) {
        print("data store");
        print(response.body);
      }
      else {
        print("error");
      }
    }
    catch(ex) {
      print(ex);
    }

  }




}
