// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:googledistanceapp/Constant/Screen.dart';

class isolatePage extends StatefulWidget {
  const isolatePage({super.key});

  @override
  State<isolatePage> createState() => _isolatePageState();
}

class _isolatePageState extends State<isolatePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _receivePort = ReceivePort();
  }

  int heavyLoad(int iteration) {
    int value = 0;

    for (int i = 0; i < iteration; i++) value = i++;

    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.amber,
        // alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  heavyLoad(4000000000);
                },
                child: Text("Start Heavy Process without Isolate")),
            ElevatedButton(
                onPressed: () {
                  useIsolate();
                },
                child: Text("Start Heavy Process with isolate"))
          ],
        ),
      ),
    );
  }

  late ReceivePort _receivePort;
  StreamSubscription? _streamSubscription;

  late SendPort _sendPort;

   useIsolate() async {
         ReceivePort port  = new ReceivePort();
    if (port != null) {
      port.close();
    }
    try {
     final islol = await Isolate.spawn(runTask, [port.sendPort, 4000000000]);
            islol.kill(priority: Isolate.immediate);

          print("isolate spawning");
    } on Object {
      print("Isolate Failed");
      port.close();
    }
  int i = await port.first;
              print('data Processed ${i}');

    // final response = await _receivePort.first;
    // _streamSubscription = _receivePort.listen((message) {
    //   if (message is SendPort) {
    //     _sendPort = message;
    //         print('data Processed ${message}');

    //   } else {
    //     print(message);
    //   }
    // });
  }
   runTask(List<dynamic> args) {
    SendPort resultPort = args[0];
    int value = 0;
    for (int i = 0; i < args[1]; i++) value = i++;
// resultPort.send(message)
resultPort.send(value);
  }
  //  useIsolate2()async{
  //       ReceivePort port  = new ReceivePort();
  //      final islol =await Isolate.spawn<List<dynamic>>(deserialize, [port.sendPort,response.body,response.statusCode]);
  //     // GetLeadStatusModal enquiryReferral =await port.first;
  //      islol.kill(priority: Isolate.immediate);
  // }
  //        deserialize(List<dynamic> values){
  //   SendPort sendPort = values[0];
  //   String responce = values[1];
  //   int rescode = values[2];
    // Map<String,dynamic> dataMap = jsonDecode(responce);
    // var result = GetLeadStatusModal.fromJson(dataMap, rescode);
    // sendPort.send(result);
  // }
}
