import 'dart:async';
import 'dart:convert';
import 'package:coffeebeansattendanceapp/screens/LastScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  GoogleSignInAccount _currentUser;

  var qrstr = " ";
  bool scanButtonDisable=true;
  bool submitButtonDisable=false;

  bool checkboxImageDisable=false;
  bool scanImageDisable=false;
  bool failqrcode=false;

  String location = 'Null, Press Button';
  String Address = 'search';
  TextEditingController Textcontroller = new TextEditingController();
  String qrcode;
  var listdata;
  var data;
  String localdate = DateFormat("EEEEE, MMMM, dd").format(DateTime.now());
  var apidate;

  var enable;

  @override
  void initState() {
    super.initState();
    _fetchPost();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser=account;
      });
    });
    _googleSignIn.signInSilently();

    Textcontroller.addListener(() {
      enable=Textcontroller.text.isNotEmpty;
       setState(()=>this.checkboxImageDisable=enable);

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
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: 30,
            left: 10,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(),
                    child: Image.asset('assets/shelf2.png',height: 140,)),
              ],
            ),
          ),
          Positioned(
            left: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top:250),
                  child: Text('Check in',style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF553205)),),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:310),
                  child: Text('Record your body temperature',style: TextStyle(fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal,
                    fontWeight:FontWeight.w500 ,
                    fontSize: 18,
                    color:const Color(0xFF553205),
                  ),),
                )
              ],
            ),
          ),

          Positioned(
            left: 30,
              width: 150,
              child: Container(
                margin: EdgeInsets.only(top:350,),
                child: TextField(
                  controller : Textcontroller,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),
                  decoration:
                  new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF553205)),
                    ),
                    enabledBorder: new  OutlineInputBorder(
                        borderSide: const  BorderSide(color: Color(0xFF553205)),
                    ),
                    prefixText: "\t",
                    suffixIcon:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("°F",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,
                          color: const Color(0xFFCAB9A3)),),
                    ),
                  ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),


        // textfeild check image
          Positioned(
            left: 190,
            child: Column(
              children: [
                GestureDetector(
                  child: Visibility(
                    visible: checkboxImageDisable,
                    child: Container(
                      margin: EdgeInsets.only(top:360),
                      child: Image(
                        image: Image.asset("assets/small-check.png").image
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 30,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:430),
                  child: Text('Scan the QR code at the entrance',style :TextStyle(fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal,
                    fontWeight:FontWeight.w500 ,
                    fontSize: 18,
                    color:const Color(0xFF553205),
                  )),
                )
              ],
            ),
          ),
          Positioned(
            left: 30,
            child: Column(
              children: [
              Container(
                margin: EdgeInsets.only(top:470),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:const Color(0xFFE9CFAB),fixedSize: const Size(150, 50),
                    ),
                    onPressed:scanButtonDisable?() {
                              setState(()=>scanButtonDisable=true);
                              scanQr();
                              }:null,
                            child:
                            Text(('SCAN'),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,  color: const Color(0xFF654113),),)),
              ),
              ],
            ),
          ),

          // scan check image
          Positioned(
            left: 190,
            child: Column(
              children: [
                GestureDetector(
                  child:Visibility(
                    visible: scanImageDisable,
                    child: Container(
                      margin: EdgeInsets.only(top:480),
                      child: Image(
                        image: Image.asset("assets/small-check.png").image,
                      ),
                    ),
                  ),

                ),
              ],
            ),
          ),

          Positioned(
            top: 490,
            left: 190,
            child: Column(
              children: [
                GestureDetector(
                  child:Visibility(
                    visible: failqrcode,
                    child: Image(
                      image: Image.asset("assets/fail.png").image,
                    ),
                  ),

                ),
              ],
            ),
          ),

          Positioned(
            top: 490,
            left: 210,
            child: Column(
              children: [
                Text(qrstr,style: TextStyle(color:const Color(0xFF553205),fontSize: 13,fontWeight: FontWeight.w400),),
              ],
            ),
          ),
          Positioned(
            top: 570,
            left: 30,
            child: Column(
              children: [
              ElevatedButton(
                            style: ElevatedButton.styleFrom(primary:Color(0xFF422501),fixedSize: const Size(340, 50),),
                            onPressed:(checkboxImageDisable && scanImageDisable)? () {
                              setState(()=>submitButtonDisable=false);

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LastScreen())).then((value) => saveAttendanceData());
                            }:null, child: Text("DONE",style: TextStyle(fontFamily:'Montserrat',fontStyle: FontStyle.normal ,color: const Color(0xFFF6EEE3),fontWeight: FontWeight.w700,fontSize: 16),)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  var _data;

  Future _fetchPost() async  {

    print('print 1');
    http.Response response = await http.get(Uri.parse("https://attendance-application-spring.herokuapp.com/qrcode/uniqueId"));
    setState(() {
      _data = jsonEncode(response.body.toString());
      print(_data.toString());
    });
    return "Success";
  }


  Future <void>scanQr()async{
    try {

      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) async {
        setState(() {
          print("variable value is $value");
        });
        qrcode=value;
        if(value=="-1") {
          failqrcode=false;
          Text(qrstr=" ");
        }
        else if(qrcode==_data) {
          scanButtonDisable=false;
          scanImageDisable=true;
          failqrcode=false;
          Text(qrstr=" ");
          // scanImageDisable=!scanImageDisable;
        }
        else if(qrcode==_data) {
          scanButtonDisable=false;
          scanImageDisable=true;
          failqrcode=false;
          Text(qrstr=" ");
          // scanImageDisable=!scanImageDisable;
        }
        else {
          Text(qrstr="Invalid QR. Please retry.");
          submitButtonDisable=false;
          failqrcode=!failqrcode;
        }

      });
    }
    catch(e){
      setState(() {
        qrstr='unable to read this';
      });
    }
  }



  Future<void> saveAttendanceData() async {
    Position position = await _getGeoLocationPosition();
    data =  http.post(Uri.parse("https://attendance-application-spring.herokuapp.com/attendance/save"), headers:<String,String>{
      'Content-Type': 'application/json;charset=UTF-8'
    },

      body:jsonEncode({
        'email' : _currentUser.email,
        'temperature' : Textcontroller.text,
           'longitude' : position.longitude,
           'latitude' : position.latitude,
      }),
    ).then((response) => print(response.body)).catchError((error) => print(error));
    print('json data : $data');
  }
  Future getData() async {
    print('json data email,date');
    print("get data from list");
    http.Response response = await http.get(Uri.parse("https://attendance-application-spring.herokuapp.com/attendance/list"));
    setState(() {
      listdata = jsonDecode(response.body.toString())['email'];
      apidate = jsonDecode(response.body.toString())['dates'];
      print(listdata.toString());
      print(localdate);
    });
  }

}