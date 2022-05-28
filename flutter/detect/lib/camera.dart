import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta_meta.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'util.dart';
import 'landmark.dart';
import 'main.dart';

class Camera extends StatefulWidget {
  @override
  const Camera({key}) : super(key: key);
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List _recognitions; //탐지한 객체들 정보를 담은 리스트
  var target = 0; //현재 위치 gps정보를 이용해 어떤 랜드마크를 타깃으로 할지에 사용하는 변수
  double _imageHeight;
  double _imageWidth;
  CameraImage img;
  CameraController controller;
  bool isBusy = false;
  bool certification = false; //인증 여부

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    print("loadmodel~~" + target.toString());
    loadModel();
    initCamera();
  }

  // landmark list를 index 순서대로 순차탐색, gps 값을 이용해 거리를 계산해서 거리 100m 이내의 landmark를 찾으면 타깃값을 해당 index값으로 하고 함수종료
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("latitude" +
        currentPosition.latitude.toString() +
        "longitude" +
        currentPosition.longitude.toString());

    // lat1, lon1, lat2, log2, dist -> 받아온 gps좌표로 실제거리(dist) 계산하는데 사용
    var lat1 = currentPosition.latitude * math.pi / 180;
    //35.885790 * math.pi / 180;
    var lon1 = currentPosition.longitude * math.pi / 180;
    //128.614078 * math.pi / 180;
    double lat2, lon2, dist;

    for (int i = 0; i < landmark.length; i++) {
      print("compare in for loop" + i.toString());
      print("landmark" +
          i.toString() +
          " lati : " +
          landmark[i]['latitude'].toString() +
          " long : " +
          landmark[i]['longitude'].toString());
      lat2 = landmark[i]['latitude'] * math.pi / 180;
      lon2 = landmark[i]['longitude'] * math.pi / 180;
      dist = math.sin(lat1) * math.sin(lat2) +
          math.cos(lat1) * math.cos(lat2) * math.cos(lon1 - lon2);
      dist = math.acos(dist);
      dist = dist * 180 / math.pi;
      dist = dist * 60 * 1.1515;
      dist *= 1609.344;
      print("distance : " + dist.toString());
      //반경 100m
      if (dist < 100) {
        target = i;
        Fluttertoast.showToast(msg: nameList[target] + " 찾기");
        return;
      }
    }

    print("target is -1");
    target = -1; // 반경 100m안에 타깃이 없을경우
    Fluttertoast.showToast(msg: "근처에 타깃이 없습니다. \n위치정보를 다시 확인합니다.");
  }

  //모델 불러오기
  Future loadModel() async {
    Tflite.close();
    try {
      String res = await Tflite.loadModel(
        model: "assets/converted_model.tflite",
        labels: "assets/converted_model.txt",
        // useGpuDelegate: true,
      );
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  //카메라 초기화
  initCamera() {
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.startImageStream((image) => {
              if (!isBusy) {isBusy = true, img = image, runModelOnFrame()}
            });
      });
    });
  }

  //비디오 실시간 객체 탐지
  //TODO process frame
  runModelOnFrame() async {
    _imageWidth = img.width + 0.0;
    _imageHeight = img.height + 0.0;
    _recognitions = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: "YOLO",
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5, //127.5  // 0
      imageStd: 127.5, //127.5  //255.0
      numResultsPerClass: 1,
      threshold: 0.6, //컨피던스0.6 이상부터 탐지
    );
    print(_recognitions.length);
    isBusy = false;
    setState(() {
      img;
    });
  }

  //카메라 껐을때
  @override
  void dispose() {
    super.dispose();
    controller.stopImageStream();
    Tflite.close();
  }

  //바운딩 박스 생성
  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];
    _recognitions.forEach((re) {
      print(re["detectedClass"]);
      print(re["confidenceInClass"]);

      //인증 성공했을때
      if (target != -1) {
        if (re["detectedClass"] == landmark[target]['name']) {
          Fluttertoast.showToast(msg: "인증되었습니다");
          changeDescription(target);
          setState(() {
            certification = true;
          });
        }
      }
      //인증은 성공했지만 gps정보가 일치하지 않을때
      else {
        getCurrentLocation();
      }
    });

    double factorX = screen.width;
    debugPrint("double factor x");
    double factorY = _imageHeight; // _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.red,
              fontSize: 15.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];
    stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: Container(
          height: size.height - 100,
          child: (!controller.value.isInitialized)
              ? new Container()
              : AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
        )));

    //TODO rectangle round detected objects
    if (img != null) {
      stackChildren.addAll(renderBoxes(size));
    }

    stackChildren.add(
      Container(
        height: size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary:
                          (certification == true ? Colors.black : Colors.white),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  child: Text("인증완료"),
                  onPressed: () {
                    if (certification == true) {
                      controller.pausePreview();
                      FlutterDialog(context, "인증되었습니다.");
                    }
                    // else{
                    //   Fluttertoast.showToast(msg: "아직 인증되지 않았습니다.");
                    // }
                  }),
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
              margin: EdgeInsets.only(top: 50),
              color: Colors.black,
              child: Stack(
                children: stackChildren,
              )),
        ),
      ),
      onWillPop: () {
        controller.pausePreview();
        FlutterDialog(context, "인증을 취소합니다.");
      },
    );
  }
}
