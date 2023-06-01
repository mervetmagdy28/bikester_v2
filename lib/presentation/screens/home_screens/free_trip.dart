import 'dart:async';

import 'package:bikesterr/data/models/station_model.dart';
import 'package:bikesterr/presentation/screens/home_screens/start_trip.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class FreeTrip extends StatefulWidget {
  const FreeTrip ({Key? key,}) : super(key: key);
  @override
  State<FreeTrip> createState() => _FreeTripState();
}

class _FreeTripState extends State<FreeTrip> {

  late StationModel nearestStation;
  late Position position;

  GoogleMapController? googleMapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore.collection("users").doc(currentUser!.uid).update({
      'freeTrip':true,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Trip Started,I want to end trip', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.orange)
              ),
              onPressed: (){
                getNearestStation();
                String url='https://www.google.com/maps/dir/?api=1&origin=${position.latitude.toString()},${position.longitude.toString()}&destination=${nearestStation.lat.toString()},${nearestStation.long.toString()}&travelmode=driving&dir_action=navigate';
                _launchURL(url);
              }, child: const Text('show google map'))
        ],
      ),
    ),
    );
  }

  Future<void>_launchURL(String url) async {

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("can\'t launch $url")));
    }
    setState(() {

    });
  }

  void getNearestStation() async {
    await getPosition();

     nearestStation = stations[0];
    double shortestDistance = double.infinity;

    for (StationModel station in stations) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        double.parse(station.lat!),
        double.parse(station.long!),
      );

      if (distance < shortestDistance && station.availableBikes != null) {
        shortestDistance = distance;
        nearestStation = station;
      }
    }
  }

  Future<void> getPosition() async {

    position = await _determinePosition();
    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 10)));

  }

  Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission locationPermission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();

    try {
      serviceEnable;
    } catch (e) {}

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location Permission are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream().listen((pos) {
      position= pos;
    });
    return position;
  }
}
