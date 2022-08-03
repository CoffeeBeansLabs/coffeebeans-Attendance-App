import 'dart:convert';
import 'package:coffeebeansattendanceapp/screens/ScanScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);


class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  var disable=true;
  GoogleSignInAccount _currentUser;
  String location = 'Null, Press Button';
  String Address = 'search';
  final String assetName = 'assets/Vector.svg';

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
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 30,
              left: 10,
              child: Column(
                children: [
                  Container(
                      // margin: EdgeInsets.only(),
                      child: Image.asset('assets/shelf2.png',height: 140,)),
                ],
              ),
            ),
            Positioned(
              top: 390,
              left: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text("Hi, "+_currentUser.displayName+"!" ?? '',style: TextStyle(fontSize: 22,color: const Color(0xFF3E2723),fontWeight:FontWeight.w700),),
                ],
              ),
            ),

            Positioned(
              top: 420,
              left: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you at the office today?",style: TextStyle(fontSize: 18,color: Colors.brown[300]),),
                ],
              ),
            ),

                Positioned(
                top: 470,
                  left: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.brown[900],
                            fixedSize: const Size(330, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          saveEmployeeData();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanScreen()));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('CHECK IN',style: TextStyle(fontFamily: 'Montserrat',
                              fontStyle: FontStyle.normal,
                              fontWeight:FontWeight.w700 ,
                              fontSize: 16,
                              color:const Color(0xFFF6EEE3),
                            ),), // <-- Text
                            SizedBox(
                              width: 5,
                            ),
                        SvgPicture.asset('assets/Vector.svg',height: 10,),
                            // Image.asset('assets/Vector.png',height: 20,)

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
          ],
        ),
      );



    }
    else {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image(
              image: AssetImage("assets/loginpage.jpg"),
              fit: BoxFit.cover,
            ),
            ),
            Positioned(
              left: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                      Container(
                          margin: EdgeInsets.only(top: 150),
                          child: Image.asset('assets/logo.png',height: 120,)),
                ],
              ),
            ),
            Positioned(
              left: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 350),
                    child: Text('Sign in with your Coffeebeans \nemail to continue',style: TextStyle(fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal,
                      fontWeight:FontWeight.w400 ,
                      fontSize: 20,
                      color:const Color(0xFFFFFFFF),

                    ),),
                  ),
                ],
              ),

            ),
            Positioned(
              left: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    margin: EdgeInsets.only(top:420),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          fixedSize: const Size(330, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),

                          )),
                      onPressed: () {
                        _handleSignIn();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/google.png',height: 38,width: 38,),
                          Text('SIGN IN',style: TextStyle(fontFamily: 'Montserrat',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:const Color(0xFF757575),

                          ),),
                       // <-- Text
                          SizedBox(
                            width: 5,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ),

          ],
        ),
      );


    }
  }
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place
        .postalCode}, ${place.country}';
    setState(() {});
  }


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Position position = await _getGeoLocationPosition();
      location =
      'Lat: ${position.latitude} , Long: ${position.longitude}';
      GetAddressFromLatLong(position);



    } catch (error) {
      print(error);
    }
  }





  Future<void> saveEmployeeData() {

   var data =  http.post(Uri.parse("https://attendance-application-spring.herokuapp.com/employee/save"), headers:<String,String>{
      'Content-Type': 'application/json;charset=UTF-8'
    },
      body:jsonEncode({
        'email':_currentUser.email,
        'name':_currentUser.displayName
      }),

    ).then((response) => print(response.body)).catchError((error) => print(error));

   print(data);

  }



}
