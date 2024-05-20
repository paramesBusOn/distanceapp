// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls, avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class TabbarController extends ChangeNotifier {
  // Position? currentPosition;
  // Position? currentPosition2;
  Position? currentPosition3;

  // Position? previousPosition;
  // Position? previousPosition2;
  Position? previousPosition3;

  // StreamSubscription<Position>? positionStream;
  // StreamSubscription<Position>? positionStream2;
  StreamSubscription<Position>? positionStream3;

  // double totalDistance = 0;
  // double totalDistancetest1 = 0;

  double totalDistance2 = 0;
  double totalDistance2_2 = 0;

  double totalDistance3 = 0;

  // static double totalDistance2 = 0;
  // List<Position> locationsTest1Before = [];
  // List<Position> locationsTest1After = [];
//
  List<Position> locationsTest2Before = [];
  List<Position> locationsTest2After = [];

  List<Position> locationsTest3Before = [];
  List<Position> locationsTest3After = [];
  //
  int distanceFilter2 = 0;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  bool clearprogress = false;

  clearAllTestData() async {
    // timer!.cancel();
    clearprogress = true;
    distanceFilter2 = 0;
    // timerCount = 0;
    timerCount2 = 0;
    // clearAll();
    // clearAll2();
    clearAll3();
    clearprogress = false;
    notifyListeners();
  }

  startmethod() async {
    // clearAll();
    clearAll2();
    clearAll3();
    notifyListeners();
  }

  Map<String, double> addDistance(
      double lat, double lon, double distanceInMeters) {
    // Earth's radius in meters
    const double earthRadius = 6378137.0;

    // Convert latitude and longitude from degrees to radians
    double latRadians = lat * (pi / 180.0);
    double lonRadians = lon * (pi / 180.0);

    // Calculate new latitude
    double newLat = lat + (distanceInMeters / earthRadius) * (180.0 / pi);

    // Calculate new longitude
    double newLon =
        lon + (distanceInMeters / earthRadius) * (180.0 / pi) / cos(latRadians);

    return {'latitudeEtc': newLat, 'longitudeEtc': newLon};
  }

  bool startbool = false;
  init() async {
    startbool = true;

    await startmethod();
    // test2();
    // test1();
    test3();

    _addMarker(LatLng(originLatitude, originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(destLatitude, destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    startbool = false;

    notifyListeners();
  }

  // int timerCount = 0;

  // Future<void> test1() async {
  //   positionStream = Geolocator.getPositionStream(
  //       locationSettings: LocationSettings(
  //     distanceFilter: distanceFilter2,
  //     accuracy: LocationAccuracy.high,
  //     // timeLimit: Duration(seconds: 10)
  //   )).listen((Position position) async {
  //     timerCount = timerCount + 1;
  //     print('TimerCount1:' + timerCount.toString());

  //     // if ((await Geolocator.isLocationServiceEnabled())) {
  //     //   Geolocator.getCurrentPosition(
  //     //           desiredAccuracy: LocationAccuracy.high,
  //     //           forceAndroidLocationManager: true)
  //     //       .then((Position position) {
  //     currentPosition = position;
  //     originLatitude = currentPosition!.latitude;
  //     originLongitude = currentPosition!.longitude;

  //     // locationsTest1Before.add(currentPosition!);
  //     locationsTest1Before.add(Position(
  //         longitude: currentPosition!.longitude,
  //         latitude: currentPosition!.latitude,
  //         altitudeAccuracy: currentPosition!.altitudeAccuracy,
  //         speedAccuracy: currentPosition!.speedAccuracy,
  //         timestamp: currentPosition!.timestamp,
  //         accuracy: currentPosition!.accuracy,
  //         altitude: currentPosition!.altitude,
  //         heading: totalDistance,
  //         headingAccuracy: currentPosition!.headingAccuracy,
  //         speed: currentPosition!.speed));

  //     if (locationsTest1Before.length > 1) {
  //       previousPosition =
  //           locationsTest1Before.elementAt(locationsTest1Before.length - 2);
  //       destLatitude = previousPosition!.latitude;
  //       destLongitude = previousPosition!.longitude;

  //       if (previousPosition!.latitude.toStringAsFixed(8) !=
  //               currentPosition!.latitude.toStringAsFixed(8) &&
  //           previousPosition!.longitude.toStringAsFixed(8) !=
  //               currentPosition!.longitude.toStringAsFixed(8)) {
  //         // var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
  //         //   previousPosition!.latitude,
  //         //   previousPosition!.longitude,
  //         //   currentPosition!.latitude,
  //         //   currentPosition!.longitude,
  //         // );

  //         Map<String, double> newCoordinates = addDistance(
  //             previousPosition!.latitude, previousPosition!.longitude, 1.0);
  //         //
  //         double? latEtc = newCoordinates["latitudeEtc"];
  //         double? longEtc = newCoordinates["longitudeEtc"];
  //         // totalDistance=totalDistance*1000;
  //         print('test1-1Before::' + totalDistancetest1.toString() + '::');

  //         double totalMetre = totalDistancetest1 * 1000;

  //         print('test1-1after::' + totalDistancetest1.toString() + '::');
  //         if (totalMetre > 1) {
  //           totalDistancetest1 = 0;
  //           locationsTest1After.add(Position(
  //               longitude: currentPosition!.longitude,
  //               latitude: currentPosition!.latitude,
  //               altitudeAccuracy: currentPosition!.altitudeAccuracy,
  //               speedAccuracy: currentPosition!.speedAccuracy,
  //               timestamp: currentPosition!.timestamp,
  //               accuracy: currentPosition!.accuracy,
  //               altitude: currentPosition!.altitude,
  //               heading: totalDistance,
  //               headingAccuracy: currentPosition!.headingAccuracy,
  //               speed: currentPosition!.speed));
  //           totalDistance += calculateDistance(
  //               currentPosition!.latitude,
  //               currentPosition!.longitude,
  //               previousPosition!.latitude,
  //               previousPosition!.longitude);

  //           totalDistancetest1 = calculateDistance(
  //               currentPosition!.latitude,
  //               currentPosition!.longitude,
  //               previousPosition!.latitude,
  //               previousPosition!.longitude);
  //           // _totalDistance=_totalDistance/1000;
  //           notifyListeners();
  //           print('Total Distance1: $totalDistance');
  //         } else {
  //           totalDistancetest1 += calculateDistance(
  //               currentPosition!.latitude,
  //               currentPosition!.longitude,
  //               previousPosition!.latitude,
  //               previousPosition!.longitude);
  //         }
  //         // print(
  //         //     'Befor:${currentPosition3!.latitude},,${currentPosition3!.longitude} Initial Latitude: $newCoordinates , Result:${latEtc},,${longEtc}');
  //       }
  //     }
  //     notifyListeners();
  //   });
  //   // await test2();
  // }

  int timerCount2 = 0;
  int timerCount3 = 0;
  int conditionMetre = 2;
  double totalMetre = 0.0;
  Timer? timer;
  Timer? timer2;

  cancelTimer() {
    // positionStream!.cancel();
    timer!.cancel();
    timer2!.cancel();
  }

  // Future test2() async {
  //   // clearAll2();
  //   if ((await Geolocator.isLocationServiceEnabled())) {
  //     timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best,
  //       );
  //       timerCount2 = timerCount2 + 1;
  //       print('TimerCount2:' + timerCount2.toString());
  //       currentPosition2 = position;
  //       // locationsTest2Before.add(currentPosition2!);
  //       locationsTest2Before.add(Position(
  //           longitude: currentPosition2!.longitude,
  //           latitude: currentPosition2!.latitude,
  //           altitudeAccuracy: currentPosition2!.altitudeAccuracy,
  //           speedAccuracy: currentPosition2!.speedAccuracy,
  //           timestamp: currentPosition2!.timestamp,
  //           accuracy: currentPosition2!.accuracy,
  //           altitude: currentPosition2!.altitude,
  //           heading: totalDistance2,
  //           headingAccuracy: currentPosition2!.headingAccuracy,
  //           speed: currentPosition2!.speed));

  //       if (locationsTest2Before.length > 1) {
  //         previousPosition2 =
  //             locationsTest2Before.elementAt(locationsTest2Before.length - 2);
  //         if (previousPosition2!.latitude.toStringAsFixed(8) !=
  //                 currentPosition2!.latitude.toStringAsFixed(8) &&
  //             previousPosition2!.longitude.toStringAsFixed(8) !=
  //                 currentPosition2!.longitude.toStringAsFixed(8)) {
  //           // var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
  //           //   previousPosition!.latitude,
  //           //   previousPosition!.longitude,
  //           //   currentPosition!.latitude,
  //           //   currentPosition!.longitude,
  //           // );
  //           Map<String, double> newCoordinates = addDistance(
  //               previousPosition2!.latitude, previousPosition2!.longitude, 0.5);
  //           //
  //           double? latEtc = newCoordinates["latitudeEtc"];
  //           double? longEtc = newCoordinates["longitudeEtc"];
  //           // totalDistance=totalDistance*1000;
  //           print('test2-2Before::' + totalDistance2_2.toString() + '::');

  //           totalMetre = totalDistance2_2 * 1000;
  //           print('test2-2After::' + totalMetre.toString() + '::');

  //           if (totalMetre > conditionMetre) {
  //             totalDistance2_2 = 0.0;
  //             totalMetre = 0.0;
  //             locationsTest2After.add(Position(
  //                 longitude: currentPosition2!.longitude,
  //                 latitude: currentPosition2!.latitude,
  //                 altitudeAccuracy: currentPosition2!.altitudeAccuracy,
  //                 speedAccuracy: currentPosition2!.speedAccuracy,
  //                 timestamp: currentPosition2!.timestamp,
  //                 accuracy: currentPosition2!.accuracy,
  //                 altitude: currentPosition2!.altitude,
  //                 heading: totalDistance2,
  //                 headingAccuracy: currentPosition2!.headingAccuracy,
  //                 speed: currentPosition2!.speed));

  //             totalDistance2 += calculateDistance(
  //                 currentPosition2!.latitude,
  //                 currentPosition2!.longitude,
  //                 previousPosition2!.latitude,
  //                 previousPosition2!.longitude);
  //             totalDistance2_2 += calculateDistance(
  //                 currentPosition2!.latitude,
  //                 currentPosition2!.longitude,
  //                 previousPosition2!.latitude,
  //                 previousPosition2!.longitude);
  //             // _totalDistance=_totalDistance/1000;
  //             notifyListeners();
  //             print('Total Distance2: $totalDistance2');
  //           } else {
  //             // if(currentPosition2!.latitude>latEtc!&&currentPosition2!.longitude>longEtc!){
  //             totalDistance2_2 += calculateDistance(
  //                 currentPosition2!.latitude,
  //                 currentPosition2!.longitude,
  //                 previousPosition2!.latitude,
  //                 previousPosition2!.longitude);

  //             // }
  //           }
  //         }
  //       }
  //       notifyListeners();
  //     });
  //     // });
  //   }
  //   // await test3();
  //   notifyListeners();
  // }

  // List<latlongdetails> data = [];
  // List<latlongdetails> datatest2 = [];
  // List<latlongdetails> datatest1 = [];
  // List<latlongdetails> datatest3 = [];
  // String path = '';
  String path2 = '';
  String path3 = '';

  // Future<void> createExcel() async {
  //   final xcel.Workbook workbook = xcel.Workbook();
  //   final xcel.Worksheet sheet = workbook.worksheets[0];
  //   // final xcel.Worksheet sheet2 = workbook.worksheets[1];

  //   // sheet.getRangeByName('A1').setText('Hello World!');
  //   sheet.getRangeByIndex(1, 1).setText("Lat");
  //   sheet.getRangeByIndex(1, 2).setText("Long");
  //   sheet.getRangeByIndex(1, 3).setText("Total Dis");
  //   sheet.getRangeByIndex(1, 4).setText("Timestamp");

  //   //
  //   sheet.getRangeByIndex(1, 10).setText("Lat");
  //   sheet.getRangeByIndex(1, 11).setText("Long");
  //   sheet.getRangeByIndex(1, 12).setText("Total Dis");
  //   sheet.getRangeByIndex(1, 13).setText("Timestamp");

  //   for (var i = 0; i < locationsTest1Before.length; i++) {
  //     final item = locationsTest1Before[i];
  //     sheet.getRangeByIndex(i + 2, 1).setText(item.latitude.toString());
  //     sheet.getRangeByIndex(i + 2, 2).setText(item.longitude.toString());
  //     sheet.getRangeByIndex(i + 2, 3).setText(item.heading.toString());
  //     sheet.getRangeByIndex(i + 2, 4).setText(item.timestamp.toString());
  //   }

  //   for (var i = 0; i < locationsTest1After.length; i++) {
  //     final item = locationsTest1After[i];
  //     sheet.getRangeByIndex(i + 2, 10).setText(item.latitude.toString());
  //     sheet.getRangeByIndex(i + 2, 11).setText(item.longitude.toString());
  //     sheet.getRangeByIndex(i + 2, 12).setText(item.heading.toString());
  //     sheet.getRangeByIndex(i + 2, 13).setText(item.timestamp.toString());
  //   }

  //   final List<int> bytes = workbook.saveAsStream();
  //   workbook.dispose();

  //   path = await getExternalDocumentPath();
  //   var id = new DateTime.now().millisecondsSinceEpoch;

  //   // final String path = (await getApplicationSupportDirectory()).path;
  //   final String fileName =
  //       Platform.isIOS ? '$path\\Output.xlsx' : '$path/$id-test1.xlsx';
  //   final File file = File(fileName);
  //   await file.writeAsBytes(bytes, flush: true);
  //   notifyListeners();
  // }

  Future<void> createExcelTest2() async {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    // final xcel.Worksheet sheet2 = workbook.worksheets[1];

    // sheet.getRangeByName('A1').setText('Hello World!');
    sheet.getRangeByIndex(1, 1).setText("Lat");
    sheet.getRangeByIndex(1, 2).setText("Long");
    sheet.getRangeByIndex(1, 3).setText("Total Dis");
    sheet.getRangeByIndex(1, 4).setText("Timestamp");

    //
    sheet.getRangeByIndex(1, 10).setText("Lat");
    sheet.getRangeByIndex(1, 11).setText("Long");
    sheet.getRangeByIndex(1, 12).setText("Total Dis");
    sheet.getRangeByIndex(1, 13).setText("Timestamp");

    for (var i = 0; i < locationsTest2Before.length; i++) {
      final item = locationsTest2Before[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 3).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 4).setText(item.timestamp.toString());
    }

    for (var i = 0; i < locationsTest2After.length; i++) {
      final item = locationsTest2After[i];
      sheet.getRangeByIndex(i + 2, 10).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 11).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 12).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 13).setText(item.timestamp.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    path2 = await getExternalDocumentPath();
    var id = new DateTime.now().millisecondsSinceEpoch;

    // final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isIOS ? '$path2\\Output.xlsx' : '$path2/$id-test2.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    notifyListeners();
  }

  Future<void> createExcelTest3() async {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    // final xcel.Worksheet sheet2 = workbook.worksheets[1];

    // sheet.getRangeByName('A1').setText('Hello World!');
    sheet.getRangeByIndex(1, 1).setText("Lat");
    sheet.getRangeByIndex(1, 2).setText("Long");
    sheet.getRangeByIndex(1, 3).setText("Total Dis");
    sheet.getRangeByIndex(1, 4).setText("Timestamp");

    //
    sheet.getRangeByIndex(1, 10).setText("Lat");
    sheet.getRangeByIndex(1, 11).setText("Long");
    sheet.getRangeByIndex(1, 12).setText("Total Dis");
    sheet.getRangeByIndex(1, 13).setText("Timestamp");

    for (var i = 0; i < locationsTest3Before.length; i++) {
      final item = locationsTest3Before[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 3).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 4).setText(item.timestamp.toString());
    }

    for (var i = 0; i < locationsTest3After.length; i++) {
      final item = locationsTest3After[i];
      sheet.getRangeByIndex(i + 2, 10).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 11).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 12).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 13).setText(item.timestamp.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    path3 = await getExternalDocumentPath();
    var id = new DateTime.now().millisecondsSinceEpoch;

    // final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isIOS ? '$path3\\Output.xlsx' : '$path3/$id-test3.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    notifyListeners();
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    print('Status::' + status.toString());
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = (await getExternalStorageDirectory())!;
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path2: $exPath");
    await Directory(exPath).create(recursive: true);
    print("Saved Path3: $exPath");

    return exPath;
  }

  // clearAll() {
  //   timerCount = 0;
  //   path = '';
  //   currentPosition;
  //   previousPosition;
  //   positionStream;
  //   totalDistance = 0;
  //   // totalDistance2 = 0;
  //   locationsTest1Before = [];
  //   locationsTest1After = [];
  //   notifyListeners();
  // }

  clearAll2() {
    timerCount2 = 0;
    path2 = '';
    // currentPosition2;
    // previousPosition2;
    // positionStream2;
    totalDistance2 = 0;
    // totalDistance2 = 0;
    locationsTest2Before = [];
    locationsTest2After = [];
    notifyListeners();
  }

  clearAll3() {
    timerCount3 = 0;
    path3 = '';
    currentPosition3;
    previousPosition3;
    positionStream3;
    totalDistance3 = 0;
    // totalDistance2 = 0;
    locationsTest3Before = [];
    locationsTest3After = [];
    notifyListeners();
  }
  //

  //
  Future<void> test3() async {
    timer2 = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      timerCount3 = timerCount3 + 1;

      // if ((await Geolocator.isLocationServiceEnabled())) {
      //   Geolocator.getCurrentPosition(
      //           desiredAccuracy: LocationAccuracy.high,
      //           forceAndroidLocationManager: true)
      //       .then((Position position) {
      currentPosition3 = position;
      // locationsTest1Before.add(currentPosition!);
      locationsTest3Before.add(Position(
          longitude: currentPosition3!.longitude,
          latitude: currentPosition3!.latitude,
          altitudeAccuracy: currentPosition3!.altitudeAccuracy,
          speedAccuracy: currentPosition3!.speedAccuracy,
          timestamp: currentPosition3!.timestamp,
          accuracy: currentPosition3!.accuracy,
          altitude: currentPosition3!.altitude,
          heading: totalDistance3,
          headingAccuracy: currentPosition3!.headingAccuracy,
          speed: currentPosition3!.speed));

      if (locationsTest3Before.length > 1) {
        previousPosition3 =
            locationsTest3Before.elementAt(locationsTest3Before.length - 2);
        if (previousPosition3!.latitude.toStringAsFixed(8) !=
                currentPosition3!.latitude.toStringAsFixed(8) &&
            previousPosition3!.longitude.toStringAsFixed(8) !=
                currentPosition3!.longitude.toStringAsFixed(8)) {
          // Map<String, double> newCoordinates = addDistance(
          //     previousPosition!.latitude, previousPosition!.longitude, 1.0);

          // double? latEtc = newCoordinates["latitudeEtc"];
          // double? longEtc = newCoordinates["longitudeEtc"];

          // if (currentPosition3!.latitude > latEtc! &&
          //     currentPosition3!.longitude > longEtc!) {
          print('TimerCount3:' + timerCount3.toString());

          locationsTest3After.add(Position(
              longitude: currentPosition3!.longitude,
              latitude: currentPosition3!.latitude,
              altitudeAccuracy: currentPosition3!.altitudeAccuracy,
              speedAccuracy: currentPosition3!.speedAccuracy,
              timestamp: currentPosition3!.timestamp,
              accuracy: currentPosition3!.accuracy,
              altitude: currentPosition3!.altitude,
              heading: totalDistance3,
              headingAccuracy: currentPosition3!.headingAccuracy,
              speed: currentPosition3!.speed));
          // Map<String, double> newCoordinates = addDistance(
          //     currentPosition3!.latitude, currentPosition3!.longitude, 10.0);
          // double latEtc =
          //     double.parse(newCoordinates["latitudeEtc"].toString());
          // double longEtc =
          //     double.parse(newCoordinates["longitudeEtc"].toString());

          // print(
          //     'Befor:${currentPosition3!.latitude},,${currentPosition3!.longitude} Initial Latitude: $newCoordinates , Result:$latEtc,,$longEtc');

          totalDistance3 += calculateDistance(
              currentPosition3!.latitude,
              currentPosition3!.longitude,
              previousPosition3!.latitude,
              previousPosition3!.longitude);
          // _totalDistance=_totalDistance/1000;
          notifyListeners();
          print('Total Distance3: $totalDistance3');
          // }
        }
      }
      notifyListeners();
    });
  }

  GoogleMapController? mapController;
  double originLatitude = 0.0, originLongitude = 0.0;
  double destLatitude = 0.0, destLongitude = 0.0;
  // double originLatitude = 26.48424, originLongitude = 50.04551;
  // double destLatitude = 26.46423, destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAdvVumVzr7teF3UDRchglwonf_vjvXtZo";

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        draggable: true,
        markerId: markerId,
        icon: descriptor,
        position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    notifyListeners();
  }

  _getPolyline() async {
    // polylinePoints!=null
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originLatitude, originLongitude),
      PointLatLng(destLatitude, destLongitude),
      travelMode: TravelMode.driving,
      // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba  Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
