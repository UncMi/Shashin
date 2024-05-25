import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shashin/main.dart';


class InfoRoute extends StatefulWidget {
  const InfoRoute({Key? key}) : super(key: key);

  @override
  State<InfoRoute> createState() => InfoRouteState();
}

Future<void> uploadImage(File imageFile, BuildContext context) async {
  final url = Uri.parse('https://shashin-9.onrender.com/upload');  // Ensure URL is updated
  final request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  try {
    final response = await request.send().timeout(const Duration(seconds: 180));

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
      print('Upload successful: $data');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Image uploaded successfully'),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CoinInfoScreen(data: data),
        ),
      );
    } else {
      print('Upload failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed with status: ${response.statusCode}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Upload timed out. Please try again.'),
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e) {
    print('Upload failed: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upload failed: $e'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}


bool isLoading = false;

class InfoRouteState extends State<InfoRoute> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Info Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                  print("Camera button pressed");
                  SharedData.cameraState = 0;
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
                    SizedBox(width: 8),
                    Text(
                      "Discard",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  print("Camera button pressed");
                  setState(() {
                    isLoading =
                        true; // Set isLoading to true when starting upload
                  });
                  try {
                    await uploadImage(File(SharedPhoto.photo1.path), context);
                  } finally {
                    setState(() {
                      isLoading =
                          false; // Reset isLoading after upload finishes
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 36,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child:
                  CircularProgressIndicator(), // Display progress indicator while isLoading is true
            ),
        ],
      ),
    );
  }
}

class CoinInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const CoinInfoScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CoinInfoScreen> createState() => _CoinInfoScreenState();
}

class _CoinInfoScreenState extends State<CoinInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Simulating loading delay
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final coinInfo = widget.data['coin_info'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 46, 53, 52),
      ),
      backgroundColor: const Color.fromARGB(255, 76, 88, 87),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Coin info',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                      if (coinInfo != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Number: ${coinInfo['Number'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Period: ${coinInfo['Period'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Denomination: ${coinInfo['Denomination'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Year: ${coinInfo['Year'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Coin type: ${coinInfo['Coin type'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                // Add other fields as needed
                              ],
                            ),
                          ],
                        ),
                      ] else
                        const Text(
                          'No coin info available.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          SharedData.cameraState = 0;
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
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
                            const SizedBox(
                                width: 8), // Add space between icon and text
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