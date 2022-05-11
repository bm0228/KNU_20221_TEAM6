import 'package:flutter/material.dart';
import 'camera.dart';
import 'landmark.dart';
import 'checklist.dart';

class home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (Text("크누투어")), backgroundColor: Colors.red[700]),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.warning, size: 50.0),
          SizedBox(height: 30.0),
          Text(
              '<인증 유의사항>\n\n\n타겟 전체 모습이 카메라 화면에 나오도록\n카메라를 세로로 들고 정면에서 비춰주세요.\n\n인증이 완료되면 인증완료 버튼을 눌러주세요.\n\n보행 중에는 주변을 계속 살피세요.\n\n체크리스트를 통해 타겟 정보를 확인할 수 있습니다',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
              textAlign: TextAlign.center),
          SizedBox(height: 100.0),
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


