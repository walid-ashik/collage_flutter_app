import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LFIT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LFIT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile = null;
  int bottomTabBarIndex = 0;
  ScreenshotController screenshotController = ScreenshotController();

  incrementBottomTabBarIndex(index) {
    setState(() {
      bottomTabBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Screenshot(
              controller: screenshotController,
              child: createCanvas(deviceWidth))),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.white70,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  print("image capturing start...");
                  takeScreenShot();
                },
                child: Container(
                  height: 50.0,
                  child: Center(child: Icon(Icons.save_alt)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50.0,
                child: Center(child: Icon(Icons.share)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createCanvas(double deviceWidth) {
    double canvasSize = deviceWidth - 50.0;

    return Container(
      height: canvasSize,
      width: canvasSize,
      child: Column(
        children: <Widget>[
          Container(
            height: canvasSize / 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.amberAccent,
                    child: Center(child: Text('A')),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: Center(child: Text('B')),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: canvasSize / 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: Center(child: Text('C')),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.amberAccent,
                    child: Center(child: Text('D')),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void takeScreenShot() async {

    final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
    String fileName = DateTime.now().toIso8601String();
    final path = '$directory/$fileName.png';

    screenshotController.capture(path: path, pixelRatio: 10.0).then((File imageFile) async {
      setState(() {
        _imageFile = imageFile;
      });

      final result =
      await ImageGallerySaver.saveImage(_imageFile.readAsBytesSync());
      print('image has been saved');
    });
  }
}
