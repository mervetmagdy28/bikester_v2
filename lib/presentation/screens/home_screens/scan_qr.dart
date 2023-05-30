import 'dart:developer';
import 'dart:io';
import 'package:bikesterr/data/models/station_model.dart';
import 'package:bikesterr/presentation/screens/home_screens/start_trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../constants.dart';
import '../../../data/models/trip_info.dart';
import 'end_trip.dart';


class ScanQr extends StatelessWidget {
  const ScanQr({Key? key, required this.stationModel}) : super(key: key);

  final StationModel stationModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Scan QR of Bike')),
      body: Center(
        child:  QRViewExample(stationModel: stationModel,),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key, required this.stationModel}) : super(key: key);

  final StationModel stationModel;
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: scanQr(),
      builder:(context,snapshot)=> Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.orange)
                            ),
                              onPressed: () async {
                                await qrController?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: qrController?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.orange)
                              ),
                              onPressed: () async {
                                await qrController?.flipCamera();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: qrController?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                        'Camera facing ${describeEnum(snapshot.data!)}');
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // scannedQr()async {
  //
  //   if (trips.isEmpty){
  //     if (result?.code != null) {
  //       await controller?.pauseCamera();
  //       Get.offAll(() =>  StartTrip(stationModel: widget.stationModel,));
  //     }
  //   }
  //   for(TripInfo tripInfo in trips){
  //     print('$tripInfo llllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
  //         if(tripInfo.flag! ==false){
  //           if (result?.code != null) {
  //             await controller?.pauseCamera();
  //             Get.offAll(() =>  EndTrip(stationModel: widget.stationModel,));
  //           }
  //         }
  //       }
  //   for(TripInfo tripInfo in trips){
  //     print('$tripInfo llllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
  //     if(tripInfo.flag! ==true){
  //       if (result?.code != null) {
  //         await controller?.pauseCamera();
  //         Get.offAll(() =>  StartTrip(stationModel: widget.stationModel,));
  //       }
  //     }
  //   }
  // }
  //



  scanQr()async{


    if (result?.code != null) {
      await qrController?.pauseCamera();
     // Get.offAll(() =>  StartTrip(stationModel: widget.stationModel,));
    }
   if(userData['hasActiveRide']==false){
   //startTrip
     print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
     firestore.collection("users").doc(currentUser!.uid).update({
       'hasActiveRide': true ,
       'activeRideDetails':{
         'startStation': 'widget.stationModel.stationName',
         'startTime': getCurrentTime(),
       }
     });
     print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
     Get.offAll(()=> StartTrip(stationModel: widget.stationModel,));

   }else{
     //endTrip
     print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
     firestore.collection("users").doc(currentUser!.uid).update({
       'hasActiveRide': false ,
       'activeRideDetails':{
         'endStation': 'widget.stationModel.st',
         'endTime': getCurrentTime(),
       }
     });
     print('sssssssssssssssssssssssssssssssssssss');
     //await userDataController.fetchData();
     Get.offAll(()=> EndTrip());

   }
  }
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }


  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }



}