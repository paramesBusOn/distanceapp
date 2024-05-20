import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class TestOneClass {
 static Position? previousPosition;
 static Position? currentPosition;
 static StreamSubscription<Position>? positionStream;
 static double totalDistance = 0;
 static double totalDistancetest1 = 0;
 static List<Position> locationsTest1Before = [];
 static List<Position> locationsTest1After = [];
 static int? timerCount=0;
 static String? path = '';
 static int distanceFilter2 = 0;
//

 static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

static Future<void> testOnerGetDistance() async {
    positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      distanceFilter: distanceFilter2,
      accuracy: LocationAccuracy.high,
      // timeLimit: Duration(seconds: 10)
    )).listen((Position position) async {
      timerCount = timerCount! + 1;
      print('TimerCount1--:' + timerCount.toString());

      // if ((await Geolocator.isLocationServiceEnabled())) {
      //   Geolocator.getCurrentPosition(
      //           desiredAccuracy: LocationAccuracy.high,
      //           forceAndroidLocationManager: true)
      //       .then((Position position) {
      currentPosition = position;
      // originLatitude = currentPosition!.latitude;
      // originLongitude = currentPosition!.longitude;

      // locationsTest1Before.add(currentPosition!);
      locationsTest1Before.add(Position(
          longitude: currentPosition!.longitude,
          latitude: currentPosition!.latitude,
          altitudeAccuracy: currentPosition!.altitudeAccuracy,
          speedAccuracy: currentPosition!.speedAccuracy,
          timestamp: currentPosition!.timestamp,
          accuracy: currentPosition!.accuracy,
          altitude: currentPosition!.altitude,
          heading: totalDistance,
          headingAccuracy: currentPosition!.headingAccuracy,
          speed: currentPosition!.speed));

      if (locationsTest1Before.length > 1) {
        previousPosition =
            locationsTest1Before.elementAt(locationsTest1Before.length - 2);
        // destLatitude = previousPosition!.latitude;
        // destLongitude = previousPosition!.longitude;

        if (previousPosition!.latitude.toStringAsFixed(8) !=
                currentPosition!.latitude.toStringAsFixed(8) &&
            previousPosition!.longitude.toStringAsFixed(8) !=
                currentPosition!.longitude.toStringAsFixed(8)) {
          // var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
          //   previousPosition!.latitude,
          //   previousPosition!.longitude,
          //   currentPosition!.latitude,
          //   currentPosition!.longitude,
          // );

          // Map<String, double> newCoordinates = addDistance(
          //     previousPosition!.latitude, previousPosition!.longitude, 1.0);
          // //
          // double? latEtc = newCoordinates["latitudeEtc"];
          // double? longEtc = newCoordinates["longitudeEtc"];
          // totalDistance=totalDistance*1000;
          print('test1-1Before::' + totalDistancetest1.toString() + '::');

          double totalMetre = totalDistancetest1 * 1000;

          print('test1-1after::' + totalDistancetest1.toString() + '::');
          if (totalMetre > 1) {
            totalDistancetest1 = 0;
            locationsTest1After.add(Position(
                longitude: currentPosition!.longitude,
                latitude: currentPosition!.latitude,
                altitudeAccuracy: currentPosition!.altitudeAccuracy,
                speedAccuracy: currentPosition!.speedAccuracy,
                timestamp: currentPosition!.timestamp,
                accuracy: currentPosition!.accuracy,
                altitude: currentPosition!.altitude,
                heading: totalDistance,
                headingAccuracy: currentPosition!.headingAccuracy,
                speed: currentPosition!.speed));
            totalDistance += calculateDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                previousPosition!.latitude,
                previousPosition!.longitude);

            totalDistancetest1 = calculateDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                previousPosition!.latitude,
                previousPosition!.longitude);
            // _totalDistance=_totalDistance/1000;
            print('Total Distance1: $totalDistance');
          } else {
            totalDistancetest1 += calculateDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                previousPosition!.latitude,
                previousPosition!.longitude);
          }
          // print(
          //     'Befor:${currentPosition3!.latitude},,${currentPosition3!.longitude} Initial Latitude: $newCoordinates , Result:${latEtc},,${longEtc}');
        }
      }
    });
  }

static  Future<void> createExcel() async {
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

    for (var i = 0; i < locationsTest1Before.length; i++) {
      final item = locationsTest1Before[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 3).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 4).setText(item.timestamp.toString());
    }

    for (var i = 0; i < locationsTest1After.length; i++) {
      final item = locationsTest1After[i];
      sheet.getRangeByIndex(i + 2, 10).setText(item.latitude.toString());
      sheet.getRangeByIndex(i + 2, 11).setText(item.longitude.toString());
      sheet.getRangeByIndex(i + 2, 12).setText(item.heading.toString());
      sheet.getRangeByIndex(i + 2, 13).setText(item.timestamp.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    path = await getExternalDocumentPath();
    var id = DateTime.now().millisecondsSinceEpoch;

    // final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isIOS ? '$path\\Output.xlsx' : '$path/$id-test1.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
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

static  clearAll() {
    timerCount = 0;
    path = '';
    currentPosition;
    previousPosition;
    // positionStream;
    totalDistance = 0;
    // totalDistance2 = 0;
    locationsTest1Before = [];
    locationsTest1After = [];
  }
}
