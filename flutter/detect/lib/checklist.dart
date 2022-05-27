import 'dart:convert';

import 'package:flutter/material.dart';
import 'landmark.dart';
import 'webviews.dart';
import 'home.dart';

class Checklist extends StatefulWidget {
  @override
  const Checklist({key}) : super(key: key);
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  //랜드마크 리스트 눌렀을때 팝업띄우는 함수
  void showPopup(context, title, image, decription) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      image,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      decription,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('닫기'),
                      style: ElevatedButton.styleFrom(primary: Colors.red)),
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MaterialApp(
            title: '체크리스트',
            home: Scaffold(
              appBar: AppBar(
                title: Text("체크리스트"),
                backgroundColor: Colors.red[700],
              ),
              //리스트뷰 사용하여 체크리스트 구현
              body: ListView.builder(
                  itemCount: landmark.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      //랜드마크 리스트 누르면 팝업 띄워줌
                      onTap: () {
                        showPopup(context, nameList[index], imageList[index],
                            description[index]);
                      },
                      child: Card(
                          child: Row(children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(imageList[index]),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              Text(nameList[index],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(description[index],
                                      style: TextStyle(fontSize: 15)))
                            ]))
                      ])),
                    );
                  }),
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
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebViews()));
                      break;
                    case 1:
                      changelinkList(index);
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebViews()));
                      break;
                    case 2:
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => home()),
                      );
                      break;
                    case 3:
                      changelinkList(index);
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Checklist()));
                      break;
                    case 4:
                      changelinkList(index);
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebViews()));
                      break;
                    default:
                  }
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.star), label: '인사말'),
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: '코스안내'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.camera_alt), label: '투어인증'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.checklist), label: '체크리스트'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.circle_notifications_outlined),
                      label: '공지사항')
                ],
              ),
            )));
  }
}
