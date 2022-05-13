import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  String premission = await callPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '인증',
      theme: ThemeData(brightness: Brightness.light, primaryColor: Colors.blue),
      home: home(),
    );
  }
}

//카메라, 마이크 권한 요청하는 함수 (카메라앱이 영상이라 마이크 권한 필요한듯함)
Future<String> callPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();

  if (statuses.values.every((element) => element.isGranted)) {
    return 'success';
  }

  return 'failed';
}
