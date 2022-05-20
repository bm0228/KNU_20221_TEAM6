import 'package:flutter/material.dart';
import 'camera.dart';
import 'landmark.dart';
import 'checklist.dart';
import 'webviews.dart';

class home extends StatefulWidget {
  @override
  const home({key}) : super(key: key);
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱 이름
      appBar: AppBar(title: (Text("크누투어")), backgroundColor: Colors.red[700]),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.warning, size: 50.0),
        SizedBox(height: 30.0),
        // 안내문구
        Text(
            '<인증 유의사항>\n\n\n타겟 전체 모습이 카메라 화면에 나오도록\n카메라를 세로로 들고 정면에서 비춰주세요.\n\n인증이 완료되면 인증완료 버튼을 눌러주세요.\n\n보행 중에는 주변을 계속 살피세요.\n\n체크리스트를 통해 타겟 정보를 확인할 수 있습니다',
            style: TextStyle(color: Colors.black, fontSize: 15.0),
            textAlign: TextAlign.center),
        SizedBox(height: 50.0),
        ElevatedButton(
            onPressed: () {
              //인증하기(카메라 화면)으로 전환
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
              //체크리스트 화면으로 전환
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Checklist()),
              );
            },
            child: Text('체크리스트', style: TextStyle(fontSize: 20.0)),
            style: ElevatedButton.styleFrom(primary: Colors.red))
      ])),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              changelinkList(index);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WebViews()));
              break;
            case 1:
              changelinkList(index);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WebViews()));
              break;
            case 2:
              home();
              break;
            case 3:
              changelinkList(index);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WebViews()));
              break;
            case 4:
              changelinkList(index);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WebViews()));
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '인사말'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '코스안내'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '투어인증'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '인증샷'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '공지사항')
        ],
      ),
    );
  }
}
