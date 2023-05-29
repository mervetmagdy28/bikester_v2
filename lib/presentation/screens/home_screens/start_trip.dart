import 'package:bikesterr/data/models/station_model.dart';
import 'package:bikesterr/presentation/screens/home_screens/destiation_trip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import  'package:intl/intl.dart';
import '../../../constants.dart';

class StartTrip extends StatefulWidget {
  const StartTrip({Key? key, required this.stationModel}) : super(key: key);
  final StationModel stationModel;

  @override
  State<StartTrip> createState() => _StartTripState();
}

class _StartTripState extends State<StartTrip> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addRide();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.orange,
        title: const Text("Trip Started"),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 1,),
            const Image(image:AssetImage('assets/biking.png',),width: 250),
            const Spacer(flex: 4,),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orange)
              ),
                onPressed: (){

                },
                child: const Text("     Free Trip    ")),
            const Spacer(flex: 1,),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)
                ),
                onPressed: (){
                  Get.to(()=>const DestinationTrip());
                },
                child: const Text("Direct Station")),
            const Spacer(flex: 10,),

          ],
        ),
      ),
    );
  }

  addRide(){
    trip.add({
      'flag': false,
      'begin station Name': widget.stationModel.stationName,
      'begin trip': getCurrentTime(),
      'end station Name':null.toString(),
      'end trip':null.toString(),
    });
  }

  String getCurrentTime(){
    String datetime = DateTime.now().toString();
    datetime= DateFormat("MMMM, dd, yyyy").format(DateTime.now());
    String hourDate = DateFormat("hh:mm:ss a").format(DateTime.now());
    return '$hourDate  $datetime';
  }
}
