import 'dart:io';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:sandbox/components/formProduct.dart';
import 'package:sandbox/screens/home.dart';

class CameraManager extends StatefulWidget {
  final CameraDescription camera;
  CameraManager({super.key, required this.camera});
  State<CameraManager> createState() => Picture();
}

class Picture extends State<CameraManager> {
  late CameraController controller;
  late Future<void> initControllerFuture;
  String imageName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future takePicture() async {
    try {
      XFile picture = await controller.takePicture();
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return PagePreview(image: picture);
      }));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        (controller.value.isInitialized)
            ? CameraPreview(controller)
            : Container(
                child: Center(child: CircularProgressIndicator()),
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              child: Row(
            children: [
              Expanded(
                  child: IconButton(
                onPressed: takePicture,
                icon: Icon(Icons.circle),
              ))
            ],
          )),
        ),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ));
  }
}

class PagePreview extends StatelessWidget {
  final XFile image;
  int count = 0;
  PagePreview({super.key, required this.image});

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(color: Colors.red ,icon: Icon(Icons.arrow_back), onPressed: () => {
            Navigator.of(context)
              ..pop()
              ..pop(image.name)
          },),
         Image.file(File(image.path), fit: BoxFit.cover, width: 250.0,)
        ],
      )
    );
  }
}
