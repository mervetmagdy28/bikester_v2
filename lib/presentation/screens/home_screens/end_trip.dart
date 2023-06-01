import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../data/models/station_model.dart';

class EndTrip extends StatefulWidget {
  const EndTrip({Key? key, required this.startStation, required this.endStation, required this.startTime, required this.endTime,}) : super(key: key);
//  final StationModel stationModel;

  final String startStation;
  final String endStation;
  final String startTime;
  final String endTime;
  @override
  State<EndTrip> createState() => _EndTripState();
}

class _EndTripState extends State<EndTrip> {

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
      ),
      body: Column(

        children: [
           const Image(image: AssetImage('assets/route.png',),width: 250,),
          
         const  Center(child: Text("Trip Ended Successfully", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
          Row(
            children: [
              Text("start station ${widget.startStation}")
            ],
          ),
          Row(
            children: [
              Text("End station ${widget.endStation}")
            ],
          ),
          Row(
            children: [
              Text("start Time ${widget.startTime}")
            ],
          ),
          Row(
            children: [
              Text("end Time ${widget.endTime}")
            ],
          ),
        ],
      ),
    );
  }

  addRide(){
    rides.add({
        'startStation':widget.startStation,
        'startTime': widget.startTime,
        'endStation': widget.endStation,
        'endTime': widget.endTime,
    });
  }


}
