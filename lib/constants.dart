import 'package:bikesterr/domain/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'domain/controllers/stations_controller.dart';
import 'domain/controllers/trip_controller.dart';
import 'domain/controllers/user_data_controller.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference rides = firestore.collection('rides');

var stationController = Get.put(StationsController());
//var tripController = Get.put(TripController());
var userDataController = Get.put(UserDataController());

var stations = stationController.allStations.value;
final auth = FirebaseAuth.instance;
var currentUser=auth.currentUser;

var userData = userDataController.userData.value;

//var trips = tripController.trips.value;

String getCurrentTime(){
  String datetime = DateTime.now().toString();
  datetime= DateFormat("MMMM, dd, yyyy").format(DateTime.now());
  String hourDate = DateFormat("hh:mm:ss a").format(DateTime.now());
  return '$hourDate  $datetime';
}