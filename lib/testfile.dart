// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, camel_case_types, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, non_constant_identifier_names, unnecessary_new, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:math';

// import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class TestApp extends StatefulWidget {
  TestApp({Key? key}) : super(key: key);

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAdvVumVzr7teF3UDRchglwonf_vjvXtZo";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(11.0142342, 76.9625101);
  // LatLng endLocation = LatLng(30.6875440, 85.2751138);

  double distance = 0.0;

  double latnew = 0.0;
  double longnew = 0.0;

  @override
  void initState() {
    setState(() {
      determinePosition();
    });

    super.initState();
  }

  int distanse2 = 0;
  // static LocationSettings locationSettings = LocationSettings(
  //   accuracy: LocationAccuracy.best,
  //   distanceFilter: distanse2,
  // );

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // log("Location permission true"+permission.toString());
      Geolocator.openLocationSettings();
    } else {
      permission = await Geolocator.checkPermission();

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

  List<latlongdetails> data = [];
  List<latlongdetails> datatest2 = [];
  List<latlongdetails> datatest1 = [];
  List<latlongdetails> datatest3 = [];

  double totalDistance = 0;
  List<latlongdetails> data2 = [];

  Future<void> locationCheck() async {
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      distanceFilter: distanse2,
      accuracy: LocationAccuracy.high,
    )).listen((Position? position) async {
      //2

      //1
      setState(() {
        double oldlat = 0.00;
        double oldlong = 0.00;
        latnew = position!.latitude;
        longnew = position.longitude;
        print('lat::' + latnew.toString());
        print('long::' + longnew.toString());
        // print('dis From Speed::' + position.speed.toString());

        if (startLatitude != 0.00 && startLongtitue != 0.00) {
          data2.add(
              latlongdetails(lat: latnew, long: longnew, totaldistance: 0.0));

          data = data2.toSet().toList();

          datatest1.add(latlongdetails(
              lat: latnew, long: longnew, totaldistance: totalDistance));
          datatest2 = datatest1.toSet().toList();

          if (data.length == 1) {
            oldlat = latnew;
            oldlong = longnew;
            // datatest2.add(latlongdetails(
            //     lat: latnew, long: longnew, totaldistance: totalDistance));

            // newcalculation(distanse2, position.speed);

            // if (data[data.length].lat != oldlat &&
            //     data[data.length].long != oldlong) {
            //   totalDistance += calculateDistance(oldlat, oldlong,
            //       data[data.length].lat, data[data.length].long);
            // }
          } else {
            oldlat = data[data.length - 2].lat;
            oldlong = data[data.length - 2].long;
            if (datatest2[data.length - 2].lat.toString() !=
                    datatest2[data.length - 1].lat.toString() &&
                datatest2[data.length - 2].long.toString() !=
                    datatest2[data.length - 1].long.toString()) {
              datatest3.add(latlongdetails(
                  lat: latnew, long: longnew, totaldistance: TotalDis2));
              TotalDis2 += calculateDistance2(datatest2[data.length - 2].lat,
                  datatest2[data.length - 2].long, latnew, longnew);
            }

            totalDistance +=
                calculateDistance(oldlat, oldlong, latnew, longnew);
          }

          print('distance:::' + totalDistance.toString());
        }

        setState(() {
          distance = totalDistance;
        });
      });
    });
  }

  double? startLatitude = 0.00;
  double? startLongtitue = 0.00;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      startLatitude = position.latitude;
      startLongtitue = position.longitude;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    print('process lat' + lat1.toString());
    print('process long' + lon1.toString());

    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculateDistance2(lat1, lon1, lat2, lon2) {
    print('process lat' + lat1.toString());
    print('process long' + lon1.toString());

    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double TotalDis2 = 0.0;
  double TotalDis3 = 0.0;

  newcalculation(int met, double speed2) {
    //D = (Speed x Time)
    double D = 0.0;
    double Speed = speed2;
    double Time = 0.0;

    print(' Speed' + Speed.toString());

    Time = 60 / met;
    print(' Bef Time' + Time.toString());

    Time = Time / 60;

    print(' Time' + Time.toString());

    D = (Speed * Time);
    print(' Dis New' + D.toString());
    TotalDis2 += D;
    print('Total DIs' + TotalDis3.toString());
  }

  clearall() {
    setState(() {
      data.clear();
      latnew = 0.00;
      longnew = 0.00;
      distance = 0.0;
      startLatitude = 0.00;
      startLongtitue = 0.00;
      totalDistance = 0;
      // distanse2 = 0;
      TotalDis2 = 0;
      TotalDis3 = 0;
    });
  }

  setstring2(String temp) {
    setState(() {
      if (temp.isNotEmpty) {
        if (containsInteger(temp)) {}
        distanse2 = int.parse(temp.toString());
      }
    });
  }

  bool containsInteger(String input) {
    // Regular expression to check if the string contains an integer
    final RegExp regex = RegExp(r'\b\d+\b');

    return regex.hasMatch(input);
  }

  Future<void> exportexcel() async {
    //   final xcel.Workbook workbook = xcel.Workbook();
    //   final xcel.Worksheet sheet = workbook.worksheets[0];
    //   sheet.getRangeByIndex(1, 1).setText("Lat");
    //   sheet.getRangeByIndex(1, 2).setText("Long");
    //   sheet.getRangeByIndex(1, 3).setText("Total Dis");

    //   for (var i = 0; i < data.length; i++) {
    //     final item = data[i];
    //     sheet.getRangeByIndex(i + 2, 1).setText(item.lat.toString());
    //     sheet.getRangeByIndex(i + 2, 2).setText(item.long.toString());
    //     sheet.getRangeByIndex(i + 2, 3).setText(item.totaldistance.toString());
    //   }
    //   final List<int> bytes = workbook.saveAsStream();
    // // final Uint8List bytes2 = await readByteStream(bytes);

    //   final path = await _localPath;
    //       // final String directory = await getExternalDocumentPath();

    //   // await Future.delayed(Duration(seconds: 3));
    //   // Create a file for the path of
    //   // device and file name with extension
    //   final String path2 =
    //       path+'/exported_excel.xlsx'; // Adjust the path accordingly
    //   print("Save Path:" + path2.toString());

    //   File file = File(path2);

    //   // Write the data in the file you have created
    //   await file.writeAsBytes(bytes,flush: true).whenComplete(() {
    //   print("Save file");

    //   });

    //   workbook.dispose();

    // File('wewwe.xlsx').writeAsBytes(bytes);
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

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculate Distance"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            'Start Point ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: 200,
                            child:
                                Text('${startLatitude} , ${startLongtitue}')),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            'Live ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: 200, child: Text('${latnew} , ${longnew}')),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          // color: Colors.amber,
                          child: Text(
                            'Total Dis ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 200,
                          child: Text(
                            distance.toString() + " KM ",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          // color: Colors.amber,
                          child: Text(
                            'Total Dis 2 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 200,
                          child: Text(
                            TotalDis2.toString() + " KM ",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          // color: Colors.amber,
                          child: Text(
                            'Total Dis 3 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 200,
                          child: Text(
                            TotalDis3.toString() + " KM ",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          // color: Colors.amber,
                          child: Text(
                            'Dis.Met ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 200,
                          child: Text(" ${distanse2} "),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    width: 400,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          // color: Colors.amber,
                          child: Text(
                            'Save File Path',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 200,
                          child: Text(" ${path} "),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
                        filled: true,
                        labelText: "Distant Value",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          setstring2(value);
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clearall();
                          getLocation();
                        });
                      },
                      child: Text('Start Track')),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clearall();
                          determinePosition();
                        });
                      },
                      child: Text('Clear All')),
                  //exportexcel()
                  ElevatedButton(
                      onPressed: () async {
                        await createExcel();
                      },
                      child: Text('Export Excel')),

                  Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[200],
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              leading: const Icon(Icons.list),
                              trailing: Text(
                                "${data[index].totaldistance.toString()}",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                              title: Text(
                                  "Lat: ${data[index].lat} \nLong:${data[index].long}"));
                        }),
                  )
                ]),
          ),
        ));
  }

  String path = '';
  Future<void> createExcel() async {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    // final xcel.Worksheet sheet2 = workbook.worksheets[1];

    // sheet.getRangeByName('A1').setText('Hello World!');
    sheet.getRangeByIndex(1, 1).setText("Lat");
    sheet.getRangeByIndex(1, 2).setText("Long");
    sheet.getRangeByIndex(1, 3).setText("Total Dis");
    //
    sheet.getRangeByIndex(1, 6).setText("Lat");
    sheet.getRangeByIndex(1, 7).setText("Long");
    sheet.getRangeByIndex(1, 8).setText("Total Dis");

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item.lat.toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item.long.toString());
      sheet.getRangeByIndex(i + 2, 3).setText(item.totaldistance.toString());
    }

    for (var i = 0; i < datatest3.length; i++) {
      final item = datatest3[i];
      sheet.getRangeByIndex(i + 2, 6).setText(item.lat.toString());
      sheet.getRangeByIndex(i + 2, 7).setText(item.long.toString());
      sheet.getRangeByIndex(i + 2, 8).setText(item.totaldistance.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // if (kIsWeb) {
    //   AnchorElement(
    //       href:
    //           'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    //     ..setAttribute('download', 'Output.xlsx')
    //     ..click();

    // } else {
    path = await getExternalDocumentPath();
    var id = new DateTime.now().millisecondsSinceEpoch;

    // final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\Output.xlsx' : '$path/$id.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    //
    final snackBar = SnackBar(
      content: Text('Save SucessFully..'),
      duration: Duration(seconds: 1), // Optional: Set the duration
    );

    // ScaffoldMessenger is required to show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // OpenFile.open(fileName);
    // }
  }
}

class latlongdetails {
  dynamic lat;
  dynamic long;
  double totaldistance;
  latlongdetails(
      {required this.lat, required this.long, required this.totaldistance});
}

extension ListExtension<E> on List<E> {
  addAllUnique(Iterable<E> iterable) {
    for (var element in iterable) {
      if (!contains(element)) {
        add(element);
      }
    }
  }
}
