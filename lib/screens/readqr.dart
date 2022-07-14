import 'package:coffeebeansattendanceapp/screens/Location.dart';
import 'package:coffeebeansattendanceapp/screens/TimeDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  GoogleSignInAccount _currentUser;

  var qrstr = "let's Scan it";
  var height,width;
  var disable=true;

  String location = 'Null, Press Button';
  String Address = 'search';

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
              Text(qrstr,style: TextStyle(color: Colors.blue,fontSize: 30),),
              ElevatedButton(onPressed: scanQr,
                child:
                Text(('Scan'))),
                Text('Coordinates Points',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                Text(
                location, style: TextStyle(color: Colors.black, fontSize: 16),),
                Text('ADDRESS',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              Text('${Address}'),

              RawMaterialButton(
                onPressed: () {
                  print('disable');
                  print(disable);
                  if(disable){
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TimeDate()));
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.arrow_circle_right,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
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
          qrstr="Scan Successful";
          disable=false;
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

}