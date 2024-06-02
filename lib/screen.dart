import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:shashin/main.dart';
import 'package:shashin/infoscreen.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview(this.file, {Key? key}) : super(key: key);
  final XFile file;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool showCircularImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 46, 53, 52),
      ),
      backgroundColor: Color.fromARGB(255, 76, 88, 87),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 40),
                      if (SharedData.cameraState == 0)
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Front Face (tails)',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (SharedData.cameraState == 1)
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Back Face (heads)',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      ClipOval(
                        child: Container(
                          width: 0.7 * MediaQuery.of(context).size.width,
                          height: 0.7 * MediaQuery.of(context).size.width,
                          child: Transform.translate(
                            offset: Offset(0, 0),
                            child: Image.file(
                              File(widget.file.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print("Camera button pressed");
                                if (SharedData.cameraState == 0) {
                                  Navigator.pop(context, 0);
                                } else if (SharedData.cameraState == 1) {
                                  Navigator.pop(context, 1);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_return,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Retake",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 40),
                            ElevatedButton(
                              onPressed: () {
                                print("Camera button pressed");
                                if (SharedData.cameraState == 0) {
                                  SharedPhoto.photo1 = widget.file;
                                  Navigator.pop(context, 1);
                                } else if (SharedData.cameraState == 1) {
                                  SharedPhoto.photo2 = widget.file;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InfoRoute(),
                                      ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  SizedBox(width: 0),
                                  Text(
                                    "Proceed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
