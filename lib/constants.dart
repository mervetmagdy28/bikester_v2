import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'domain/controllers/stations_controller.dart';
import 'domain/controllers/trip_controller.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference trip = firestore.collection('ride trip');

var stationController = Get.put(StationsController());
var tripController = Get.put(TripController());

var stations = stationController.allStations.value;

var trips = tripController.trips.value;

