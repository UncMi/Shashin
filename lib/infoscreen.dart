import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shashin/main.dart';

class InfoRoute extends StatefulWidget {
  const InfoRoute({super.key});

  @override
  State<InfoRoute> createState() => InfoRouteState();
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
