import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'camera.dart';

List<CameraDescription> cameras;
List<Map> landmark = [
  {'name': '북문', 'latitude': 1, 'longitude': 1},
  {'name': '정문', 'latitude': 1, 'longitude': 1},
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  //랜드마크 초기화 함수()
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home(),
    );
  }
}

class home extends StatelessWidget {
  const home({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text("home")),
      ),
      body: TextButton(
        child: Text("영래"),
        onPressed: () {
          //gps 받기

          //화면 전환 (위도 경도 값 등등 같이 넘겨주기)
        },
      ),
    );
  }
}



//landmark 초기화 함수
