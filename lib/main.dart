import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shashin/screen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          // on top of each other
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Camera button pressed");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraRoute(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(width: 30), // Add space between icon and text
                     Text(
                       "Take Coin Photo",
                      style: TextStyle(color: Colors.white), // Text with white color
                     ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Camera button pressed");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraRoute(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.browse_gallery,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(width: 30), // Add space between icon and text
                     Text(
                       "Take Photo From Gallery",
                      style: TextStyle(color: Colors.white), // Text with white color
                     ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Another button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.list,
                        color: Colors.white,
                        size: 48), // Another Icon with white color
                    SizedBox(width: 30), // Add space between icon and text
                     Text(
                       "Check Coin Database",
                      style: TextStyle(color: Colors.white), // Text with white color
                     ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Another button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.history,
                        color: Colors.white,
                        size: 48), // Another Icon with white color
                    SizedBox(width: 30), // Add space between icon and text
                     Text(
                       "Your Coin History",
                      style: TextStyle(color: Colors.white), // Text with white color
                     ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.photo_library),
        //     onPressed: () {
        //       print("pressed!");
        //     }),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'coin gallery',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                print("Home pressed");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ));
                break;
              case 1:
                print("Coin Gallery pressed");
                break;
            }
          },
        ),
      ),
    );
  }
}

class CameraRoute extends StatefulWidget {
  const CameraRoute({super.key});

  @override
  State<CameraRoute> createState() => _CameraRouteState();
}

class _CameraRouteState extends State<CameraRoute> {
  late CameraController _controller;
  int _cameraState = 0;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CameraPreview(_controller),
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: CustomPaint(
                painter: CirclePainter(),
                child: Container(),
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Front Face Of The Coin',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context); // Go back to the previous screen (camera view)
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () async {
                      if (!_controller.value.isInitialized) {
                        return null;
                      }
                      if (_controller.value.isTakingPicture) {
                        return null;
                      }

                      try {
                        await _controller.setFlashMode(FlashMode.auto);
                        XFile file = await _controller.takePicture();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImagePreview(file, _cameraState)));
                      } on CameraException catch (e) {
                        debugPrint("error while taking picture : $e");
                      }
                    },
                    child: Icon(Icons.camera, size: 48)),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double innerCircleRadius = 0.35;
  final double outerCircleRadius = 0.35;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint innerPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.dstIn;

    final Offset center = size.center(Offset.zero);

    // Draw outer circle
    canvas.drawCircle(center, outerCircleRadius * size.width, outerPaint);

    // Draw inner unblurred circle
    canvas.drawCircle(center, innerCircleRadius * size.width, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
