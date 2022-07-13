import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../widget/confetti_widget.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}
class _LocationState extends State<Location> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coordinates Points',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),

            Text(
              location, style: TextStyle(color: Colors.black, fontSize: 16),),

            Text('ADDRESS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),

            Text('${Address}'),
            ElevatedButton(onPressed: () async {
              Position position = await _getGeoLocationPosition();
              location =
              'Lat: ${position.latitude} , Long: ${position.longitude}';
              GetAddressFromLatLong(position);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AllConfettiWidget(child: Center(
                child: Center(
                  child: Center(
                    child: Text(
                        'Congratulations Your Attendance has been marked 🥳',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                  ),
                  ),))));

            }, child: Text('Mark Your Attendance')),

          ],
        ),
      ),
    );
  }
}



