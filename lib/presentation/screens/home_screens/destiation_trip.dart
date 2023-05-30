import 'dart:async';

import 'package:bikesterr/data/models/station_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../domain/controllers/stations_controller.dart';

class DestinationTrip extends StatefulWidget {
  const DestinationTrip({Key? key}) : super(key: key);

  @override
  State<DestinationTrip> createState() => _DestinationTripState();
}

class _DestinationTripState extends State<DestinationTrip> {


  List<String> stationNames=[];

  GoogleMapController? googleMapController;
  var stationController = Get.put(StationsController());
  late var defaultValue;
  late Position position;
  late StationModel destinationLoc;
  late String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stationController.getStations();
    print(stations.length);
    for(StationModel stationModel in stations){
      stationNames.add(stationModel.stationName??'station name');
    }
    defaultValue=stationNames[0];

    getPosition();
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

  getDestination(String stationName)async{
    for (StationModel stationModel in stations)
      {
        if (stationModel.stationName==stationName){
          destinationLoc=stationModel;
          var querySnapshot=await rides.get();
          querySnapshot.docs.forEach((doc) {
            id=doc.id;
          });
        }
      }
    String url='https://www.google.com/maps/dir/?api=1&origin=${position.latitude.toString()},${position.longitude.toString()}&destination=${destinationLoc.lat.toString()},${destinationLoc.long.toString()}&travelmode=driving&dir_action=navigate';
    _launchURL(url);
    rides.doc(id).update({
      'end station Name':destinationLoc.stationName
    });
  }
  @override
  Widget build(BuildContext context) {

   return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: defaultValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  defaultValue = value!;
                });
              },
              items: stationNames.map<DropdownMenuItem<String>>((String value) {
                print(value);
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange)
              ),
                onPressed: (){
                getDestination(defaultValue);

                }, child: const Text('show google map'))
          ],
        ),
      ),
    );
  }

}
