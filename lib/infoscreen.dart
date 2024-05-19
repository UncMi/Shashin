import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shashin/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class InfoRoute extends StatefulWidget {
  const InfoRoute({super.key});

  @override
  State<InfoRoute> createState() => InfoRouteState();
}

Future<void> uploadImage(File imageFile, BuildContext context) async {
  final url = Uri.parse('http://192.168.1.160:5000/upload');
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
          content: Text('Image uploaded successfully'),
          duration: Duration(seconds: 2),
        ),
      );
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
  } catch (e) {
    print('Upload failed: $e');
  }
}
class InfoRouteState extends State<InfoRoute> {
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
        backgroundColor: Color.fromARGB(255, 46, 53, 52),
      ),
      backgroundColor: Color.fromARGB(255, 76, 88, 87),
      body: Column(
        
          children: [

            SizedBox(height: 20),
            Row(children: [
              SizedBox(width:40),
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
            SizedBox(width:20),
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


            ],),
            
            const SizedBox(height: 60),

            Row(
              children: [
                SizedBox(width: 40),
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
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    print("Camera button pressed");
                    await uploadImage(File(SharedPhoto.photo1.path), context);
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
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              
              ],
            )
            
          ],
        ),
    );
  }
}
