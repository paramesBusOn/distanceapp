// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class TestTwoClass {
  static Position? previousPosition2;
  static Position? currentPosition2;
  static StreamSubscription<Position>? positionStream2;
  static double totalDistance2 = 0;
  static double totalDistance2_2 = 0;
  static List<Position> locationsTest2Before = [];
  static List<Position> locationsTest2After = [];
  static int? timerCount2 = 0;
  static String? path2 = '';
  static int distanceFilter2 = 0;
//
  static int conditionMetre = 1;
  static double totalMetre = 0.0;
  static Timer? timer;

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<void> testTworGetDistance() async {
    if ((await Geolocator.isLocationServiceEnabled())) {
      timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        timerCount2 = timerCount2! + 1;
        print('TimerCount2:' + timerCount2.toString());
        currentPosition2 = position;
        // locationsTest2Before.add(currentPosition2!);
        locationsTest2Before.add(Position(
            longitude: currentPosition2!.longitude,
            latitude: currentPosition2!.latitude,
            altitudeAccuracy: currentPosition2!.altitudeAccuracy,
            speedAccuracy: currentPosition2!.speedAccuracy,
            timestamp: currentPosition2!.timestamp,
            accuracy: currentPosition2!.accuracy,
            altitude: currentPosition2!.altitude,
            heading: totalDistance2,
            headingAccuracy: currentPosition2!.headingAccuracy,
            speed: currentPosition2!.speed));

        if (locationsTest2Before.length > 1) {
          previousPosition2 =
              locationsTest2Before.elementAt(locationsTest2Before.length - 2);
          if (previousPosition2!.latitude.toStringAsFixed(8) !=
                  currentPosition2!.latitude.toStringAsFixed(8) &&
              previousPosition2!.longitude.toStringAsFixed(8) !=
                  currentPosition2!.longitude.toStringAsFixed(8)) {
            // var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
            //   previousPosition!.latitude,
            //   previousPosition!.longitude,
            //   currentPosition!.latitude,
            //   currentPosition!.longitude,
            // );
            // Map<String, double> newCoordinates = addDistance(
            //     previousPosition2!.latitude, previousPosition2!.longitude, 0.5);
            //
            // double? latEtc = newCoordinates["latitudeEtc"];
            // double? longEtc = newCoordinates["longitudeEtc"];
            // totalDistance=totalDistance*1000;
            print('test2-2Before::' + totalDistance2_2.toString() + '::');

            totalMetre = totalDistance2_2 * 1000;

            if (totalMetre > conditionMetre) {
                          print('test2-2After::' + totalMetre.toString() + '::');

              totalDistance2_2 = 0.0;
              totalMetre = 0.0;
              locationsTest2After.add(Position(
                  longitude: currentPosition2!.longitude,
                  latitude: currentPosition2!.latitude,
                  altitudeAccuracy: currentPosition2!.altitudeAccuracy,
                  speedAccuracy: currentPosition2!.speedAccuracy,
                  timestamp: currentPosition2!.timestamp,
                  accuracy: currentPosition2!.accuracy,
                  altitude: currentPosition2!.altitude,
                  heading: totalDistance2,
                  headingAccuracy: currentPosition2!.headingAccuracy,
                  speed: currentPosition2!.speed));

              totalDistance2 += calculateDistance(
                  currentPosition2!.latitude,
                  currentPosition2!.longitude,
                  previousPosition2!.latitude,
                  previousPosition2!.longitude);
              totalDistance2_2 += calculateDistance(
                  currentPosition2!.latitude,
                  currentPosition2!.longitude,
                  previousPosition2!.latitude,
                  previousPosition2!.longitude);
              // _totalDistance=_totalDistance/1000;
              print('Total Distance2: $totalDistance2');
            } else {
              // if(currentPosition2!.latitude>latEtc!&&currentPosition2!.longitude>longEtc!){
              totalDistance2_2 += calculateDistance(
                  currentPosition2!.latitude,
                  currentPosition2!.longitude,
                  previousPosition2!.latitude,
                  previousPosition2!.longitude);

              // }
            }
          }
        }
      });
      // });
    }
  }

 static Future<void> createExcelTest2() async {
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

    path2 = await getExternalDocumentpath2();
    var id = new DateTime.now().millisecondsSinceEpoch;

    // final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isIOS ? '$path2\\Output.xlsx' : '$path2/$id-test2.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
  }

  static Future<String> getExternalDocumentpath2() async {
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

    final expath2 = _directory.path;
    print("Saved path22: $expath2");
    await Directory(expath2).create(recursive: true);
    print("Saved path23: $expath2");

    return expath2;
  }

 static clearAll2() {
  timer!.cancel();
    timerCount2 = 0;
    path2 = '';
    currentPosition2;
    previousPosition2;
    // positionStream2;
    totalDistance2 = 0;
    // totalDistance2 = 0;
    locationsTest2Before = [];
    locationsTest2After = [];
  }
}
