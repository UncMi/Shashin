import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shashin/main.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GalleryInfoRoute extends StatefulWidget {
  const GalleryInfoRoute({Key? key}) : super(key: key);

  @override
  State<GalleryInfoRoute> createState() => GalleryInfoRouteState();
}

Future<void> uploadOneImage(File imageFile, BuildContext context) async {
  final url = Uri.parse('https://shashin-15-zhte.onrender.com/gallery-upload');  
  //final url = Uri.parse('http://192.168.1.160:5000/gallery-upload');// Ensure URL is updated
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
          builder: (context) => GalleryCoinInfoScreen(data: data),
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

class GalleryInfoRouteState extends State<GalleryInfoRoute> {
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
            mainAxisAlignment: MainAxisAlignment.center, // Centering the Row
            children: [
              Center(
                child: ClipOval(
                  child: Container(
                    width: 0.6 * MediaQuery.of(context).size.width,
                    height: 0.6 * MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(SharedPhoto.photo1.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centering the Row
            children: [
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
                  print("Continue button pressed");
                  setState(() {
                    isLoading = true; // Set isLoading to true when starting upload
                  });
                  try {
                    await uploadOneImage(File(SharedPhoto.photo1.path), context);
                  } finally {
                    setState(() {
                      isLoading = false; // Reset isLoading after upload finishes
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
              child: CircularProgressIndicator(), // Display progress indicator while isLoading is true
            ),
        ],
      ),
    );
  }
}



class GalleryCoinInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const GalleryCoinInfoScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<GalleryCoinInfoScreen> createState() => _GalleryCoinInfoScreenState();
}

class _GalleryCoinInfoScreenState extends State<GalleryCoinInfoScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> saveCoinInfo() async {
  final coinInfo = widget.data['coin_info'];
  final prefs = await SharedPreferences.getInstance();
  final directory = await getApplicationDocumentsDirectory();

  // Create unique filenames using timestamps
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final photo1Path = '${directory.path}/photo1_$timestamp.png';

  final photo1File = File(SharedPhoto.photo1.path);

  await photo1File.copy(photo1Path);

  // Save coin info with images paths
  final savedData = {
    'coin_info': coinInfo,
    'photo1': photo1Path,
    'photo2': photo1Path,
  };

  final savedList = prefs.getStringList('coin_history') ?? [];
  savedList.add(jsonEncode(savedData));

  await prefs.setStringList('coin_history', savedList);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Coin info saved successfully!')),
  );
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
                              width: 0.6 * MediaQuery.of(context).size.width,
                              height: 0.6 * MediaQuery.of(context).size.width,
                              child: Image.file(
                                File(SharedPhoto.photo1.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
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
                                SizedBox(width: 8), // Add space between icon and text
                                Text(
                                  "Main Page",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: saveCoinInfo,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                SizedBox(width: 8), // Add space between icon and text
                                Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}