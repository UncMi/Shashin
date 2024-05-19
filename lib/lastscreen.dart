import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class InfoScreen extends StatefulWidget {
  InfoScreen(this.file, this.cameraState, {Key? key}) : super(key: key);
  final XFile file;
  final int cameraState;

  @override
  State<InfoScreen> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<InfoScreen> {
  bool showCircularImage = false;
  Map<String, dynamic>? coinInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    uploadImage(File(widget.file.path));
  }

  Future<void> uploadImage(File imageFile) async {
    final url = Uri.parse('http://192.168.1.160:5000/upload');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send().timeout(const Duration(seconds: 180));

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        setState(() {
          coinInfo = data['coin_info'];
          isLoading = false;
        });
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload timed out. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Upload failed: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
                              width: 0.35 * MediaQuery.of(context).size.width,
                              height: 0.35 * MediaQuery.of(context).size.width,
                              child: Image.file(
                                File(widget.file.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          ClipOval(
                            child: Container(
                              width: 0.35 * MediaQuery.of(context).size.width,
                              height: 0.35 * MediaQuery.of(context).size.width,
                              child: Image.file(
                                File(widget.file.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (coinInfo != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Number: ${coinInfo!['Number'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Period: ${coinInfo!['Period'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Denomination: ${coinInfo!['Denomination'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Year: ${coinInfo!['Year'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Coin type: ${coinInfo!['Coin type'] ?? 'N/A'}',
                                  style: TextStyle(
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
                        Text(
                          'No coin info available.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
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
