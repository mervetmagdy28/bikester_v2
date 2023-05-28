import 'package:bikesterr/data/models/station_model.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class DestinationTrip extends StatefulWidget {
  const DestinationTrip({Key? key}) : super(key: key);

  @override
  State<DestinationTrip> createState() => _DestinationTripState();
}

class _DestinationTripState extends State<DestinationTrip> {


  List<String> stationNames=[];
  late var defaultValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var stations = stationController.allStations.value;
    print(stations.length);
    for(StationModel stationModel in stations){
      stationNames.add(stationModel.stationName??'station name');
    }
    defaultValue=stationNames[0];
  }

  @override
  Widget build(BuildContext context) {
    // var stations = stationController.allStations.value;
    // print(stations.length);
    // for(StationModel stationModel in stations){
    //   stationNames.add(stationModel.stationName??'station name');
    // }
    //print(stationNames.length);

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
                  //stationNames=[];
                });
              },
              items: stationNames.map<DropdownMenuItem<String>>((String value) {
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
                onPressed: (){}, child: const Text('show google map'))
          ],
        ),
      ),
    );
  }

}
