import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'camera.dart';
import 'landmark.dart';
import 'checklist.dart';
import 'home.dart';
import 'package:webview_flutter/webview_flutter.dart';

var linkList = [
  "https://knu-new-tour.flash21.com/greet",
  "https://knu-new-tour.flash21.com/course",
  "",
  "",
  "https://knu-new-tour.flash21.com/board/list",
  "https://knu-new-tour.flash21.com"
];

int linkindex = 5;

void changelinkList(int index) {
  linkindex = index;
}

class WebViews extends StatefulWidget {
  @override
  WebViewsState createState() => WebViewsState();
}

class WebViewsState extends State<WebViews> {
  WebViewController _webViewController;

  final Completer<WebViewController> _completerController =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: () => _goBack(context),
            child: Scaffold(
              body: WebView(
                onWebViewCreated: (WebViewController webViewController) {
                  _completerController.future
                      .then((value) => _webViewController = value);
                  _completerController.complete(webViewController);
                },
                initialUrl: linkList[linkindex],
                javascriptMode: JavascriptMode.unrestricted,
              ),
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

  Future<bool> _goBack(BuildContext context) async {
    if (_webViewController == null) {
      return true;
    }

    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
