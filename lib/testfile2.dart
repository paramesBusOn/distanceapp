// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, camel_case_types, unnecessary_import, sized_box_for_whitespace, unused_local_variable, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_new, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googledistanceapp/Constant/Screen.dart';
import 'package:googledistanceapp/Constant2/Test1Class.dart';
import 'package:googledistanceapp/Constant2/Test2Class.dart';
import 'package:googledistanceapp/Controller/tabController.dart';
import 'package:googledistanceapp/main.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'Constant/SharedPreference.dart';

class testAppTwo extends StatefulWidget {
  const testAppTwo({Key? key}) : super(key: key);

  @override
  State<testAppTwo> createState() => testAppTwoState();
}

class testAppTwoState extends State<testAppTwo> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // controller = new TabController(vsync: this, length: 3, initialIndex: 0);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await SharedPref.saveStartTimer(true);

      setState(() {
        // containerwieth();
        determinePosition();
        // _initForegroundTask();

        context.read<TabbarController>().clearAllTestData();
        // context.read<TabbarController>().test2();
        // context.read<TabbarController>().test3();
      });
    });
  }

  TestOneClass test1Cons = new TestOneClass();

  // void _initForegroundTask() {
  //   FlutterForegroundTask.init(
  //     androidNotificationOptions: AndroidNotificationOptions(
  //       id: 500,
  //       channelId: 'foreground_service',
  //       channelName: 'Foreground Service Notification',
  //       channelDescription:
  //           'This notification appears when the foreground service is running.',
  //       channelImportance: NotificationChannelImportance.LOW,
  //       priority: NotificationPriority.LOW,
  //       iconData: const NotificationIconData(
  //         resType: ResourceType.mipmap,
  //         resPrefix: ResourcePrefix.ic,
  //         name: 'launcher',
  //         backgroundColor: Colors.orange,
  //       ),
  //       buttons: [
  //         const NotificationButton(
  //           id: 'sendButton',
  //           text: 'Send',
  //           textColor: Colors.orange,
  //         ),
  //         const NotificationButton(
  //           id: 'testButton',
  //           text: 'Test',
  //           textColor: Colors.grey,
  //         ),
  //       ],
  //     ),
  //     iosNotificationOptions: const IOSNotificationOptions(
  //       showNotification: true,
  //       playSound: false,
  //     ),
  //     foregroundTaskOptions: const ForegroundTaskOptions(
  //       interval: 5000,
  //       isOnceEvent: false,
  //       autoRunOnBoot: true,
  //       allowWakeLock: true,
  //       allowWifiLock: true,
  //     ),
  //   );
  // }

  // containerwieth(double value, double metre, double width) {
  //   if (value != 0.0 && metre != 0.0) {
  //     double result = 0.0;
  //     result = value / metre;
  //     result = result * width;
  //     print('result' + width.toString());

  //     print('result' + result.toString());
  //     return result;
  //   }
  // }

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
        // await locationCheck();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // await locationCheck();
      }
    }
  }

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Test 1'),
    Tab(text: 'Test 2'),
    Tab(text: 'Test 3'),
  ];
  TabController? controller;
  DateTime? currentBackPressTime;
  Future<bool> onbackpress() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Get.toNamed(ConstantRoutes.dashboard);
      return Future.value(true);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //     Container(
                    //       // width: Screens.width(context)*0.01,
                    // height: Screens.bodyheight(context) * 0.06,
                    //       child: TextFormField(
                    //         decoration: InputDecoration(
                    //           border: OutlineInputBorder()
                    //         ),
                    //       ),
                    //     ),
                  ],
                ),
                // Container(
                //   width: Screens.width(context) * 0.95,
                //   height: Screens.bodyheight(context) * 0.06,
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //         contentPadding: EdgeInsets.only(top: 10, left: 10),
                //         hintText: 'Distance Filter',
                //         // fillColor:Colors.white,
                //         border: OutlineInputBorder()),
                //     onChanged: (value) {
                //       setState(() {
                //         if (value.trim().isNotEmpty) {
                //           int val = int.parse(value);
                //           TestOneClass.distanceFilter2 = val;
                //           TestTwoClass.distanceFilter2 = val;

                //           context.read<TabbarController>().distanceFilter2 =
                //               val;
                //         }
                //       });
                //     },
                //   ),
                // ),
                SizedBox(
                  height: Screens.bodyheight(context) * 0.02,
                )
                // TabBar(
                //   // key: RIKeys.riKey2,
                //   controller: controller,
                //   tabs: myTabs,
                // ),
              ],
            ),
          ),
        ),
        title: Text('Total Distance'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // controller: controller,
        children: [
          Column(
            children: [
              Test1(context),
              Test2(context),
            ],
          ),
          // Test3(context),
          // Row(
          //   children: [
          //     Column(
          //       children: [
          //         Text(
          //             "${context.read<TabbarController>().originLatitude}, ${context.read<TabbarController>().originLongitude}"),
          //         Text(
          //             "${context.read<TabbarController>().destLatitude}, ${context.read<TabbarController>().destLongitude}"),
          //       ],
          //     )
          //   ],
          // ),
          // Container(
          //   height: Screens.bodyheight(context) * 0.35,
          //   width: Screens.width(context) * 0.2,
          //   child: GoogleMap(
          //     mapType: MapType.normal,

          //     initialCameraPosition: CameraPosition(
          //         target: LatLng(
          //             context.read<TabbarController>().originLatitude,
          //             context.read<TabbarController>().originLongitude),
          //         zoom: 15),
          //     // myLocationEnabled: true,
          //     // tiltGesturesEnabled: true,
          //     // compassEnabled: true,
          //     // scrollGesturesEnabled: true,
          //     // zoomGesturesEnabled: true,
          //     onMapCreated: context.read<TabbarController>().onMapCreated,
          //     markers: Set<Marker>.of(
          //         context.read<TabbarController>().markers.values),
          //     polylines: Set<Polyline>.of(
          //         context.read<TabbarController>().polylines.values),
          //   ),
          // ),
          Column(
            children: [
              // SizedBox(
              //   height: Screens.bodyheight(context) * 0.008,
              // ),
              Container(
                width: Screens.width(context) * 0.95,
                height: Screens.bodyheight(context) * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Refresh')),
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.008,
              ),
              Container(
                width: Screens.width(context) * 0.95,
                height: Screens.bodyheight(context) * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // starttimer=true;
                        context.read<MyArgumentsProvider>().setArguments(true);
                        // context.read<TabbarController>().init();
                      });
                    },
                    child: context.read<TabbarController>().startbool == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.0,
                            ),
                          )
                        : Text('Start')),
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.008,
              ),
              Container(
                width: Screens.width(context) * 0.95,
                height: Screens.bodyheight(context) * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        TestOneClass.clearAll();
                        context.read<MyArgumentsProvider>().cancelTimer2();

                        // context.read<TabbarController>().cancelTimer();

                        // context.read<TabbarController>().clearAllTestData();
                      });
                    },
                    child:
                        context.read<TabbarController>().clearprogress == false
                            ? Text('Clear All')
                            : Center(
                                child: CircularProgressIndicator(),
                              )),
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.05,
              ),
            ],
          ),
        ],
      ),
    );
  }

  SingleChildScrollView Test1(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Toatl Distance: ${TestOneClass.totalDistance}",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Count: ${TestOneClass.timerCount}',
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: Screens.width(context) * 0.4,
                    height: Screens.bodyheight(context) * 0.05,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          hintText: 'Distance Filter',
                          // fillColor:Colors.white,
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        setState(() {
                          if (value.trim().isNotEmpty) {
                            int val = int.parse(value);
                            TestOneClass.distanceFilter2 = val;
                            TestTwoClass.distanceFilter2 = val;

                            context.read<TabbarController>().distanceFilter2 =
                                val;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              // 'Distance: ${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}'),
              Row(
                children: [
                  Text(
                    'Distance Filter: ${TestOneClass.distanceFilter2}',
                  ),
                ],
              ),
              //             SizedBox(height: 50),

              // SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Screens.width(context) * 0.6,
                    // color: Colors.amber,
                    child: Text(
                      "Path: ${TestOneClass.path}",
                    ),
                  ),
                  Container(
                    width: Screens.width(context) * 0.3,
                    child: ElevatedButton(
                        onPressed: () async {
                          await TestOneClass.createExcel();
                        },
                        child: Text('Export Excel')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView Test2(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Distance: ${TestTwoClass.totalDistance2.toString()}",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Count: ${TestTwoClass.timerCount2}',
                  ),
                ],
              ),

              // 'Distance: ${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}'),
              // Row(
              //   children: [
              //     Text(
              //       'Restricted meter: ${TestTwoClass.conditionMetre} ',
              //     ),
              //   ],
              // ),
              //             SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Screens.width(context) * 0.6,
                        child: Text(
                          "Path: ${TestTwoClass.path2}",
                        ),
                      ),
                      SizedBox(
                        height: Screens.bodyheight(context) * 0.01,
                      ),
                      // Container(
                      //   height: Screens.bodyheight(context) * 0.01,
                      //   width: Screens.width(context) * 0.4,
                      //   color: Colors.grey,
                      //   child: Row(
                      //     children: const [
                      //       // AnimatedContainer(
                      //       //   transformAlignment:
                      //       //       AlignmentDirectional.centerEnd,
                      //       //   width: containerwieth(
                      //       //       TestTwoClass.totalMetre,
                      //       //       TestTwoClass.conditionMetre
                      //       //           .toDouble(),
                      //       //       Screens.width(context) * 0.4),
                      //       //   height: Screens.bodyheight(context),
                      //       //   color: Colors.blue,
                      //       //   duration: Duration(seconds: 1),
                      //       // ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  Container(
                    width: Screens.width(context) * 0.3,
                    child: ElevatedButton(
                        onPressed: () async {
                          await TestTwoClass.createExcelTest2();
                        },
                        child: Text('Export Excel')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView Test3(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Distance: ${context.watch<TabbarController>().totalDistance3}",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Count: ${context.watch<TabbarController>().timerCount3}',
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       'Distance Filter: ${context.watch<TabbarController>().distanceFilter2} ',
              //     ),
              //   ],
              // ),
              //             SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Screens.width(context) * 0.6,
                    child: Text(
                      "Path: ${context.watch<TabbarController>().path3}",
                    ),
                  ),
                  Container(
                    width: Screens.width(context) * 0.3,
                    child: ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<TabbarController>()
                              .createExcelTest3();
                        },
                        child: Text('Export Excel')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
