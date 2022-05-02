import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

import 'landmark.dart';
import 'main.dart';

class Camera extends StatefulWidget {
  @override
  const Camera({key}) : super(key: key);
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  //double _mylatitude; //위도
  //double _mylongitude; //경도
  List _recognitions; //탐지한 객체들 정보를 담은 리스트
  var target; //사용자 위치에서 탐지해야하는 타겟 랜드마크, landmark list의 index
  double _imageHeight;
  double _imageWidth;
  CameraImage img;
  CameraController controller;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    initGps();
    //print("loadmodel~~" + target.toString());
    loadModel();
    initCamera();
  }

  // gps정보를 쓰기 위해 동기적으로 불러오기 위한 함수
  void initGps() {
    initGps_f();
  }

  //gps에 맞는 landmark index를 return 받음
  Future initGps_f() async {
    //위도 경도 얻어와서 타겟 정해주기
    //mylatitude = ###;
    //mylongitude = ###;
    //if 위도 경도가 머시기머시기면
    int idx = await getCurrentLocation();
    setState(() {
      target = idx;
    });

    //print("target is " + target.toString());

    // exception
    if (target == -1) {
      print("target is -1");
    }
    //target = landmark[0]; //임시로 북문 타겟 해놓은거임
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
      threshold: 0.4,
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
    //print("Boxes_target is " + target.toString());
    //여기에 탐지됐을때 인증보내는 기능 만들어 넣음 됨
    _recognitions.forEach((re) {
      print(re["detectedClass"]);
      print(re["confidenceInClass"]);
      //print("Boxes_target is " + target.toString());

      //모델 우리껄로 바꾸면 조건문 이거로 바꿔야함
      //if (re['confidenceInClass'] >= (0.3))
      if (re["detectedClass"] == landmark[target]['name'] &&
          re['confidenceInClass'] >= (0.3)) {
        Fluttertoast.showToast(msg: "인증되었습니다");
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
              Text('YOLO'),
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            margin: EdgeInsets.only(top: 50),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}

// gps 값을 이용해 landmark list를 순차탐색, 거리 100m 이내의 landmark를 찾으면 해당 index를 return
Future<int> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  var currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  /*print("latitude" +
      currentPosition.latitude.toString() +
      "longitude" +
      currentPosition.longitude.toString());*/
  var lat1 = currentPosition.latitude * math.pi / 180;
  //35.885790 * math.pi / 180;
  var lon1 = currentPosition.longitude * math.pi / 180;
  //128.614078 * math.pi / 180;

  for (int i = 0; i < landmark.length; i++) {
    //print("compare in for loop" + i.toString());
    /*print("landmark" +
        i.toString() +
        " lati : " +
        landmark[i]['latitude'].toString() +
        " long : " +
        landmark[i]['longitude'].toString());*/
    double lat2 = landmark[i]['latitude'] * math.pi / 180;
    double lon2 = landmark[i]['longitude'] * math.pi / 180;
    double dist = math.sin(lat1) * math.sin(lat2) +
        math.cos(lat1) * math.cos(lat2) * math.cos(lon1 - lon2);
    dist = math.acos(dist);
    dist = dist * 180 / math.pi;
    dist = dist * 60 * 1.1515;
    dist *= 1609.344;
    //print("distance : " + dist.toString());
    if (dist < 100) {
      //print("return landmark" + i.toString());
      return i;
    }
  }

  //print("return null");
  //return 1;
  return -1;
}
