import 'dart:async';
import 'package:bikesterr/data/models/station_model.dart';
import 'package:bikesterr/presentation/screens/home_screens/scan_qr.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TripRunning extends StatefulWidget {
  const TripRunning({Key? key, required this.destinationLoc}) : super(key: key);

  final StationModel destinationLoc;
  @override
  State<TripRunning> createState() => _TripRunningState();
}

class _TripRunningState extends State<TripRunning> {
  late Position position;
  GoogleMapController? googleMapController;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),

      body: Column(
        children:  [
          const Text("Trip running...", style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
          ElevatedButton(
              onPressed: (){
                String url='https://www.google.com/maps/dir/?api=1&origin=${position.latitude.toString()},${position.longitude.toString()}&destination=${widget.destinationLoc.lat.toString()},${widget.destinationLoc.long.toString()}&travelmode=driving&dir_action=navigate';
                _launchURL(url);
              },
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.orange)),
              child: const Text('go to map')),

        ],
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

  Future<void> getPosition() async {

    position = await _determinePosition();
    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 10)));

    setState(() {});
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

  scanQR(){
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      double.parse(widget.destinationLoc.lat!),
      double.parse(widget.destinationLoc.long!),
    );

    if (distance>50) {
      Get.offAll( ScanQr(stationModel: widget.destinationLoc,));
    }
  }
}











