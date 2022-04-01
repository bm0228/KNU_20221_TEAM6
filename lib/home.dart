import 'package:flutter/material.dart';
import 'package:object_detection_tiny_yolov2/main.dart';
import 'package:object_detection_tiny_yolov2/screens/home_page.dart';
import 'camera.dart';

class home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text("인증")),
      ),
      body: Center(
        child: TextButton(
          child: Text("인증하기"),
          onPressed: () {
            //화면 전환 (위도 경도 값 등등 같이 넘겨주기)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(cameras)),
            );
          },
        ),
      ),
    );
  }
}
