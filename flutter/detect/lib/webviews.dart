import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'camera.dart';
import 'landmark.dart';
import 'checklist.dart';
import 'package:webview_flutter/webview_flutter.dart';

var linkList = [
  "https://dgsw-tour.flash21.com/rule_mba?main_YN=N",
  "https://dgsw-tour.flash21.com/chart_mba_list?place=stadium",
  "",
  "https://dgsw-tour.flash21.com/free_brd_write",
  "https://dgsw-tour.flash21.com/free_board_list"
];

int linkindex = 0;

//인증여부 업데이트 함수
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
    return WillPopScope(
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
        ));
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
