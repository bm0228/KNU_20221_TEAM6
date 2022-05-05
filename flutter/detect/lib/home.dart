import 'package:flutter/material.dart';
import 'camera.dart';
import 'checklist.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: (Text("인증")),
            backgroundColor: Colors.red[700],
            centerTitle: true),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.warning, size: 50.0),
          Text(
              '안내문구 안내문구 안내문구 안내문구 안내문구 안내문구 안내문구 안내문구\n주의 주의 주의 주의 주의 주의 주의 주의 주의 주의 주의 주의 주의 주의 주의',
              style: TextStyle(color: Colors.black, fontSize: 13.0)),
          SizedBox(height: 200.0),
          ElevatedButton(
              onPressed: () {
                //화면 전환 (위도 경도 값 등등 같이 넘겨주기)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Camera()),
                );
              },
              child: Text('인증하기', style: TextStyle(fontSize: 20.0)),
              style: ElevatedButton.styleFrom(primary: Colors.red)),
          SizedBox(height: 20.0),
          ElevatedButton(
              onPressed: () {
                //도감 화면으로 전환
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Checklist()),
                );
              },
              child: Text('체크리스트', style: TextStyle(fontSize: 20.0)),
              style: ElevatedButton.styleFrom(primary: Colors.red))
        ])));
  }
}
