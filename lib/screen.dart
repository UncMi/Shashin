import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview(this.file, {Key? key});
  final XFile file;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool showCircularImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
            "Image Preview",
            style: TextStyle(
              color: Colors.white,
            ),
          ), 
          backgroundColor: Color.fromARGB(255, 46, 53, 52),),
      backgroundColor: Color.fromARGB(255, 76, 88, 87),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 0.7 * MediaQuery.of(context).size.width,
                      height: 0.7 * MediaQuery.of(context).size.width,
                      child: Image.file(
                        File(widget.file.path),
                        fit: BoxFit.cover,
                      ),
                    ),
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
