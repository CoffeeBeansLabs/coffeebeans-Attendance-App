import 'dart:convert';
import 'dart:ffi';
import 'package:coffeebeansattendanceapp/screens/LastScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  GoogleSignInAccount _currentUser;

  var qrstr = "let's Scan it";
  var height,width;
  bool disable=false;
  bool submitdisable=false;
  String location = 'Null, Press Button';
  String Address = 'search';
  TextEditingController Textcontroller = new TextEditingController();


  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser=account;
      });
    });
    _googleSignIn.signInSilently();

    Textcontroller.addListener(() {
      final disable=Textcontroller.text.isNotEmpty;

      setState(() => this.disable = disable);

    });
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


  @override
  Widget build(BuildContext context) {

    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Scanning QR code'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller : Textcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Body Temperature',
                ),

                // onChanged: (s) {
                //   int s = int.parse(
                //       Textcontroller.text);
                // },

              ),


              SizedBox(height: 16,),
              Text(qrstr,style: TextStyle(color: Colors.blue,fontSize: 30),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(onSurface: Colors.blue),
                  onPressed:disable?() {
                  setState(()=>disable=false);

                  scanQr();

                  }:null,
                child:
                Text(('Scan'))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(onSurface: Colors.blue),

                  onPressed:submitdisable? () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TimeDate())).then((value) => myFunction());

              }:null, child: Text("submit")),


            ],
          ),
        ),
    );
  }
  Future <void>scanQr()async{
    try {

      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) async {
        setState(() {
          print("variable value is $value");
          qrstr=value;
          submitdisable=true;
        });
          Position position = await _getGeoLocationPosition();
          location =
          'Lat: ${position.latitude} , Long: ${position.longitude}';
          GetAddressFromLatLong(position);
      });
    }
    catch(e){
      setState(() {
        qrstr='unable to read this';
      });
    }

  }

  Future<void> myFunction() async {

    Position position = await _getGeoLocationPosition();
    var data =  http.post(Uri.parse("http://10.0.2.2:8080/attendance/save"), headers:<String,String>{
      'Content-Type': 'application/json;charset=UTF-8'
    },
      body:jsonEncode({
        'email' : _currentUser.email,
        'temperature' : Textcontroller.text,
           'longitude' : position.longitude,
           'latitude' : position.latitude
      }),

    ).then((response) => print(response.body)).catchError((error) => print(error));

    print(data);

  }

}