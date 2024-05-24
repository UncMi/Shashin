import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shashin/main.dart';

class InfoRoute extends StatefulWidget {
  const InfoRoute({Key? key}) : super(key: key);

  @override
  State<InfoRoute> createState() => InfoRouteState();
}

class InfoRouteState extends State<InfoRoute> {
  bool isLoading = false;

  Future<void> uploadImage(File imageFile, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load and process the image
      final originalImage = img.decodeImage(imageFile.readAsBytesSync())!;
      final rotatedImage = img.copyRotate(
        originalImage,
        angle: -90, // Provide the angle parameter here
      );

      final croppedImage = img.copyCrop(
        rotatedImage,
        x: (rotatedImage.width - 256) ~/ 2, // Provide the x coordinate
        y: (rotatedImage.height - 256) ~/ 2, // Provide the y coordinate
        width: 256, // Provide the width of the cropped region
        height: 256, // Provide the height of the cropped region
      );

      // Convert image to byte array for TensorFlow Lite prediction
      final List<int> imageBytes = img.encodeJpg(croppedImage);

      // You would replace this with actual model inference code
      final predictedClass = await mockModelPrediction(imageBytes);

      // Mock fetching additional information
      final coinInfo = await mockFetchCoinInfo(predictedClass);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CoinInfoScreen(data: coinInfo),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> mockModelPrediction(List<int> imageBytes) async {
    // Simulate a model prediction
    await Future.delayed(Duration(seconds: 2));
    return 'mock_class';
  }

  Future<Map<String, dynamic>> mockFetchCoinInfo(String predictedClass) async {
    // Simulate fetching coin information based on the predicted class
    await Future.delayed(Duration(seconds: 1));
    return {
      'coin_info': {
        'Number': '10150',
        'Period': '2021',
        'Denomination': '10',
        'Year': '2021',
        'Coin type': 'Gold',
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 46, 53, 52),
      ),
      backgroundColor: const Color.fromARGB(255, 76, 88, 87),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 40),
              ClipOval(
                child: Container(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  height: 0.35 * MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(SharedPhoto.photo1.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ClipOval(
                child: Container(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  height: 0.35 * MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(SharedPhoto.photo2.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Row(
            children: [
              const SizedBox(width: 40),
              ElevatedButton(
                onPressed: () {
                  SharedData.cameraState = 0;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, color: Colors.white, size: 36),
                    SizedBox(width: 8),
                    Text("Discard", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  await uploadImage(File(SharedPhoto.photo1.path), context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, color: Colors.white, size: 36),
                    SizedBox(width: 8),
                    Text("Continue", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class CoinInfoScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const CoinInfoScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coinInfo = data['coin_info'];

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Image Preview", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 46, 53, 52),
      ),
      backgroundColor: const Color.fromARGB(255, 76, 88, 87),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Coin info',
            style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  height: 0.35 * MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(SharedPhoto.photo1.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 40),
              ClipOval(
                child: Container(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  height: 0.35 * MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(SharedPhoto.photo2.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (coinInfo != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Number: ${coinInfo['Number'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Period: ${coinInfo['Period'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Denomination: ${coinInfo['Denomination'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Year: ${coinInfo['Year'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Coin type: ${coinInfo['Coin type'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              SharedData.cameraState = 0;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera, color: Colors.white, size: 36),
                SizedBox(width: 8),
                Text("Close", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
