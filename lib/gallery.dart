import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shashin/infoscreen_gallery.dart';
import 'main.dart'; // Import main.dart to access SharedPhoto

class GalleryRoute extends StatefulWidget {
  const GalleryRoute({Key? key}) : super(key: key);

  @override
  _GalleryRouteState createState() => _GalleryRouteState();
}

class _GalleryRouteState extends State<GalleryRoute> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        SharedPhoto.photo1 = image; // Save picked image to SharedPhoto.photo1
      });
      print("Image selected from gallery: ${image.path}");
      // Handle the selected image file if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 53, 52),
        title: const Text(
          "Shashin",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 76, 88, 87),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.browse_gallery,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(width: 30),
                  Text(
                    "Pick Image From Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.file(
                File(_image!.path),
                width: 300,
                height: 300,
              ),
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                              SharedData.cameraState = 0;
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                child: Text('Return to Main Menu'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GalleryInfoRoute(),
                    ),
                  );
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
