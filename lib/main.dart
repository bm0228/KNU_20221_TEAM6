import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'camera.dart';

List<CameraDescription> cameras;
List<Landmark> landmark; //랜드마크

class Landmark {
  String name;
  double latitude; //위도
  double longitude; //경도
}

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

          //화면 전환
        },
      ),
    );
  }
}



//landmark 초기화 함수
