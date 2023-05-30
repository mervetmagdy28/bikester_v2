import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../data/models/station_model.dart';

class EndTrip extends StatefulWidget {
  const EndTrip({Key? key, required this.stationModel}) : super(key: key);
  final StationModel stationModel;
  @override
  State<EndTrip> createState() => _EndTripState();
}

class _EndTripState extends State<EndTrip> {

  late String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();

    endTrip();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: Column(

        children: const[
           Image(image: AssetImage('assets/route.png',),width: 250,),
          Center(child: Text("Trip Ended Successfully\nلقد هرمت اقسم بالله", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }

  String getCurrentTime(){
    String datetime = DateTime.now().toString();
    datetime= DateFormat("MMMM, dd, yyyy").format(DateTime.now());
    String hourDate = DateFormat("hh:mm:ss a").format(DateTime.now());
    return '$hourDate  $datetime';
  }


  getId()async{
    for (StationModel stationModel in stations)
    {
      if (stationModel.stationName==widget.stationModel.stationName){
      //  destinationLoc=stationModel;
        var querySnapshot=await trip.get();
        querySnapshot.docs.forEach((doc) {
          id=doc.id;
        });
      }
    }

  }

  endTrip()async {
    await getId();
    trip.doc(id).update({
      'flag':true,
      'end trip':getCurrentTime()
    });
  }
}
