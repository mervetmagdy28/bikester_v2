import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../data/models/station_model.dart';

class EndTrip extends StatefulWidget {
  const EndTrip({Key? key,}) : super(key: key);
//  final StationModel stationModel;
  @override
  State<EndTrip> createState() => _EndTripState();
}

class _EndTripState extends State<EndTrip> {

  //late String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDataController.fetchData();
    addRide();
   // endTrip();
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
              Text("start station ${userData['activeRideDetails']['startStation']}")
            ],
          ),
          Row(
            children: [
              Text("End station ${userData['activeRideDetails']['endStation']}")
            ],
          ),
          Row(
            children: [
              Text("start Time ${userData['activeRideDetails']['startTime']}")
            ],
          ),
          Row(
            children: [
              Text("end Time ${userData['activeRideDetails']['EndTime']}")
            ],
          ),
        ],
      ),
    );
  }

  // String getCurrentTime(){
  //   String datetime = DateTime.now().toString();
  //   datetime= DateFormat("MMMM, dd, yyyy").format(DateTime.now());
  //   String hourDate = DateFormat("hh:mm:ss a").format(DateTime.now());
  //   return '$hourDate  $datetime';
  // }
  //
  //
  // getId()async{
  //   for (StationModel stationModel in stations)
  //   {
  //     if (stationModel.stationName==widget.stationModel.stationName){
  //     //  destinationLoc=stationModel;
  //       var querySnapshot=await rides.get();
  //       querySnapshot.docs.forEach((doc) {
  //         id=doc.id;
  //       });
  //     }
  //   }
  //
  // }
  //
  // endTrip()async {
  //  // await getId();
  //   rides.doc(id).update({
  //     'flag':true,
  //     'end trip':getCurrentTime()
  //   });
  // }


  addRide(){
    var rideDetails= userData['activeRideDetails'] as Map<String , dynamic>;
    rides.add(rideDetails);
  }


}
