// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_interpolation_to_compose_strings, unused_import, avoid_print, no_leading_underscores_for_local_identifiers, await_only_futures

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googledistanceapp/testfile2.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationTrack {
  static String isChange = "";
  static String Lat = "";
  static String Long = "";
  static String Ip = "";
  static String IpName = "";

  static LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 1,
    // timeLimit:Duration(seconds: 5)
  );

  static Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // log("Location permission true"+permission.toString());
      Geolocator.openLocationSettings();
    } else {
      permission = await Geolocator.checkPermission();
      log("Location permission true" + permission.toString());

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {}
      }

      if (permission == LocationPermission.deniedForever) {
        // Geolocator.openAppSettings();
      } else {
        await locationCheck();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await locationCheck();
      }
    }
  }

  static List<Position> locations = [];
  static Position? currentPosition;
  static Position? previousPosition;
  static StreamSubscription<Position>? positionStream;
  static double totalDistance = 0;

  static Future<void> locationCheck() async {
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) async {
  await  Timer.periodic(Duration(seconds: 1), (timer) {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              )
          .then((Position position) async {
        currentPosition = position;
        locations.add(currentPosition!);

        if (locations.length > 1) {
          previousPosition = locations.elementAt(locations.length - 2);
          if (previousPosition!.latitude == currentPosition!.latitude) {
            var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
              previousPosition!.latitude,
              previousPosition!.longitude,
              currentPosition!.latitude,
              currentPosition!.longitude,
            );
            totalDistance += _distanceBetweenLastTwoLocations;
            print('Total Distance: $totalDistance');
            // testAppTwoState.totalDistance2 = totalDistance;
          }
        }
      });
    });

    // positionStream.cancel();
  }

  static clearAll() async {
    locations = [];
    currentPosition;
    previousPosition;
    positionStream;
    totalDistance = 0;
    // testAppTwoState.totalDistance2 = totalDistance;
  }

  static checkcamlocation() async {
    // PermissionStatus permission;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    log("checkcamlocation:::" + statuses[Permission.camera].toString());
    if (statuses[Permission.camera] == PermissionStatus.denied ||
        statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
      //  openAppSettings();
    } else {}
  }

  stopListening() async {
    positionStream?.cancel();
  }

  checkPermission() async {
    bool result = false;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Geolocator.openAppSettings();
        } else if (permission == LocationPermission.deniedForever) {
          // Geolocator.openAppSettings();
        } else {
          await locationCheck();
          result = true;
        }
      } else if (permission == LocationPermission.deniedForever) {
        // Geolocator.openAppSettings();
      } else {
        await locationCheck();
        result = true;
      }
    }
    return result;
  }
}


// // ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_interpolation_to_compose_strings

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:sellerkit/Constant/ConstantSapValues.dart';

// class LocationTrack with ChangeNotifier {
//   static String isChange = "";
//   static String Lat = "";
//   static String Long = "";
//   static String Ip = "";
//   static String IpName = "";

//   static LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 0,
//   );

//   static Future<void> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
// print("object1");
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     locationCheck();
    
//   }

//   static locationCheck() {
//     print("object2");

//     StreamSubscription<Position> positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position? position) {
//           print("object3"+position!.longitude.toString());    
//       if (Long.isEmpty) {
//         Long =
//             position == null ? 'Unknown' : position.longitude.toString();
//               ConstantValues.langtitude=Long;
//       }

//       if (Lat.isEmpty) {
//         Lat = position == null ? 'Unknown' : position.latitude.toString();
//          ConstantValues.latitude=Lat;
//       }
    
//       if (Long.toString() != position!.longitude.toString()) {
//         isChange = "Yes";
//         Long = position.longitude.toString();
//         ConstantValues.langtitude=Long;
//       }
//       if (Lat.toString() != position.latitude.toString()) {
//         isChange = "Yes";

//         Lat = position.latitude.toString();
//         ConstantValues.latitude=Lat;
//       }
//     });
//   }

 
// }

