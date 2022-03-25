import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'main.dart';


class Camera extends StatefulWidget {
  Camera({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  double mylatitude; //위도
  double mylongitude; //경도
  List _recognitions; //탐지한 객체들 정보를 담은 리스트
  double _imageHeight;
  double _imageWidth;
  CameraImage img;
  CameraController controller;
  bool isBusy = false;
  String result = "";

  @override
  void initState() {
    
    super.initState();
    loadModel();
    initCamera();
  }

  //모델 불러오기
  Future loadModel() async {
    Tflite.close();
    try {
      String res = await Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolov2_tiny.txt",
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


    _recognitions.forEach((re) {
      //여기에 탐지됐을때 인증보내는 함수 만들어 넣음 됨
      print(re["detectedClass"]);
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
