import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import '/screens/camera.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  MyHomePage(this.cameras);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String predOne = '';
  double confidence = 0;
  double index = 0;

  @override
  void initState() {
    super.initState();
    loadTfliteModel();
  }

  loadTfliteModel() async {
    String res;
    res = await Tflite.loadModel(
        model: "assets/dol.tflite", labels: "assets/dol.txt");
    print("res : " + res);
  }

  setRecognitions(outputs) {
    print("outputs : " + outputs.toString());

    if (outputs[0]['index'] == 0) {
      index = 0;
    } else {
      index = 1;
    }

    confidence = outputs[0]['confidence'];

    setState(() {
      predOne = outputs[0]['label'];
    });

    //알림서비스 만들곳
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "랜드마크를 찾으세요",
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Camera(widget.cameras, setRecognitions),
          //이 밑에는 전부 그래프 나타내는 코드임
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    predOne,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                    height: 32.0,
                                    child: Stack(
                                      children: [
                                        LinearProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.redAccent),
                                          //value: index == 0 ? confidence : 0.0,
                                          value: confidence,
                                          backgroundColor:
                                              Colors.redAccent.withOpacity(0.2),
                                          minHeight: 50.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            //'${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                            '${(confidence * 100).toStringAsFixed(0)} %',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       flex: 2,
                            //       child: Text(
                            //         'Orange',
                            //         style: TextStyle(
                            //             color: Colors.orangeAccent,
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 20.0),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 16.0,
                            //     ),
                            //     Expanded(
                            //       flex: 8,
                            //       child: SizedBox(
                            //         height: 32.0,
                            //         child: Stack(
                            //           children: [
                            //             LinearProgressIndicator(
                            //               valueColor:
                            //                   AlwaysStoppedAnimation<Color>(
                            //                       Colors.orangeAccent),
                            //               value: index == 1 ? confidence : 0.0,
                            //               backgroundColor: Colors.orangeAccent
                            //                   .withOpacity(0.2),
                            //               minHeight: 50.0,
                            //             ),
                            //             Align(
                            //               alignment: Alignment.centerRight,
                            //               child: Text(
                            //                 '${index == 1 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                            //                 style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.w600,
                            //                     fontSize: 20.0),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}