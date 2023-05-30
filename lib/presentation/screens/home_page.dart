import 'package:bikesterr/data/models/station_model.dart';
import 'package:bikesterr/data/models/trip_info.dart';
import 'package:bikesterr/domain/controllers/trip_controller.dart';
import 'package:bikesterr/presentation/components/appbar.dart';
import 'package:bikesterr/presentation/components/drawer.dart';
import 'package:bikesterr/presentation/screens/home_screens/trip_running.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'home_screens/all_stations.dart';
import 'home_screens/nearest_stations.dart';
import 'home_screens/profile.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screens = [ NearestStation(), AllStations(), Profile()];
  int index = 0;
  @override
  void initState() {
    tripController.getTrips();
    // TODO: implement initState
   for(TripInfo tripInfo in trips){
  if(tripInfo.flag! ==false){
    for (StationModel stationModel in stations){
      if (stationModel.stationName==tripInfo.endStationName){
        Get.to( TripRunning(destinationLoc: stationModel,));
      }
    }
  }else{

  }
}
    stationController.getStations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'nearest station'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ev_station_sharp), label: 'all stations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
      body: screens[index],
    );
  }
}
