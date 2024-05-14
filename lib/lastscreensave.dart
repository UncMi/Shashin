import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview(this.file, this.cameraState, {Key? key}) : super(key: key);
  final XFile file;
  final int cameraState;

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
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Coin info',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 0.35 *
                            MediaQuery.of(context).size.width,
                        height: 0.35 *
                            MediaQuery.of(context).size.width,
                        child: Image.file(
                          File(widget.file.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    ClipOval(
                      child: Container(
                        width: 0.35 *
                            MediaQuery.of(context).size.width,
                        height: 0.35 *
                            MediaQuery.of(context).size.width,
                        child: Image.file(
                          File(widget.file.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number:	KM# 759',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Period:	Sultan Mehmed V (1909 - 1918)',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Denomination:	5 para',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Year	AH 1327 (1909) - ١٣٢٧',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Coin type	Circulation coins',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                        onPressed: () {
                          print("Camera button pressed");
                          
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 36,
                            ),
                            SizedBox(width: 0), // Add space between icon and text
                             Text(
                               "Return To Main Page",
                               style: TextStyle(color: Colors.white),
                                // Text with white color
                             ),
                          ],
                        ),
                ),
              ],
              
            ),
          ),
        ],
      ),
    );
  }
}
