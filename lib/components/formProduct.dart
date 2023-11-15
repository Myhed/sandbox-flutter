import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import './camera.dart';

class FormManager extends StatefulWidget {
  const FormManager({super.key});
  @override
  State<FormManager> createState() => ProductForm();
}

class ProductForm extends State<FormManager> {
  final _keyForm = GlobalKey<FormState>();
  final formTextFieldController = TextEditingController();
  String imageName = '';
  void scanBarCode() async {
    print('todo barCode scan');
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      formTextFieldController.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future useCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    String name = '';
    name = await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CameraManager(camera: cameras.first);
    }));
    formTextFieldController.text = name;
  }

  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            controller: formTextFieldController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please insert something on fields";
              }
              return null;
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 16, right: 30, left: 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Code Bar'),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: scanBarCode,
                              icon: Icon(Icons.photo_camera),
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                            )
                          ]),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Ink(
                    child: InkWell(
                    onTap: () async => await useCamera(),
                    child:  DottedBorder(
                    color: Colors.brown,
                    strokeWidth: 3,
                    dashPattern: [15, 4],
                    strokeCap: StrokeCap.round,
                    child: Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.15),
                    color: Colors.brown[600],
                    child: Center(
                      child: Icon(Icons.image, color: Colors.white,),
                    ),
                  ),),
                  ),)
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: ElevatedButton(
              onPressed: () {
                if (_keyForm.currentState!.validate()) {}
              },
              child: Text('Suivant')),
        )
      ]),
    );
  }
}
