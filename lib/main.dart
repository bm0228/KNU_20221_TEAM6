// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
import 'home.dart';

// List<CameraDescription> cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '인증',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.blue
//       ),
//       home: home(),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: MyHomePage(
    //   cameras,
    // ),
    home: home(),
  ));
}

