import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shashin/gallery.dart';
import 'package:shashin/history.dart';
import 'package:shashin/screen.dart';

class SharedPhoto {
  static XFile photo1 = XFile('assets/placeholder.png');
  static XFile photo2 = XFile('assets/placeholder.png');
}

late List<CameraDescription> cameras;

class SharedData {
  static int _cameraState = 0;

  static int get cameraState => _cameraState;

  static set cameraState(int newState) {
    _cameraState = newState;
  }
}

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
            "Coin ipml-yb",
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
                  backgroundColor: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(width: 30), 
                    Text(
                      "Take Coin Photo",
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GalleryRoute(),
                      ),
                    );
                },
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
                    SizedBox(width: 30), // Add space between icon and text
                    Text(
                      "Take Photo From Gallery",
                      style: TextStyle(
                          color: Colors.white), // Text with white color
                    ),
                  ],
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistoryScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.history,
                        color: Colors.white,
                        size: 48),
                    SizedBox(width: 30), 
                    Text(
                      "Your Coin History",
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        if (SharedData._cameraState == 0)
          const Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Front Face (Tails)',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (SharedData._cameraState == 1)
          const Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Back Face (Heads)',
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
              Navigator.pop(context);
              SharedData._cameraState = 0;
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
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () async {
                      if (!_controller.value.isInitialized) {
                        return null;
                      }
                      if (_controller.value.isTakingPicture) {
                        return null;
                      }

                      try {
                        await _controller.setFlashMode(FlashMode.off);
                        XFile file = await _controller.takePicture();
                        print("AAAAAAAAAAAAAAA");
                        SharedData._cameraState = await _navigateToNextScreen(
                            context, "ImagePreview", file);
                        Navigator.pop(
                          context,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CameraRoute(),
                            ));
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

_navigateToNextScreen(
  BuildContext context,
  String routeIdentifier,
  XFile file,
) async {
  int result = -1;
  switch (routeIdentifier) {
    case RouteIdentifiers.ImagePreviewRoute:
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreview(file),
        ),
      );
      break;
  }
  return result;
}

class RouteIdentifiers {
  static const String ImagePreviewRoute = 'ImagePreview';
  static const String routeB = 'RouteB';
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

    final Offset center = Offset(size.width / 2, size.height * 0.42);

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
