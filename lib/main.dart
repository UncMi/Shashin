import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //builds when reloaded
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 46, 53, 52),
          title: const Text(
            "Shashin",
            style: TextStyle(
              color: Colors.white, // Change this to the color you desire
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 76, 88, 87),
        body: Row(
          // on top of each other
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Padding(
              padding: const EdgeInsets.all(16.0), // Add margin here
              child: ElevatedButton(
                onPressed: () {
                  print("Camera button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Change button background color to black
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, color: Colors.white), // Icon with white color
                    //SizedBox(width: 8), // Add space between icon and text
                    // Text(
                    //   "Camera",
                    //   style: TextStyle(color: Colors.white), // Text with white color
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Add margin here
              child: ElevatedButton(
                onPressed: () {
                  print("Another button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Change button background color to black
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, color: Colors.white), // Another Icon with white color
                    //SizedBox(width: 8), // Add space between icon and text
                    // Text(
                    //   "Coin Database",
                    //   style: TextStyle(color: Colors.white), // Text with white color
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.photo_library),
            onPressed: () {
              print("pressed!");
            }),
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'coin gallery',
          ),
        ]),
      ),
    );
  }
}

class CameraRoute extends StatelessWidget {
  const CameraRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
