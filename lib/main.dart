import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
        body: Row(
          // on top of each other
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 72,
                    ),
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
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Another button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list,
                        color: Colors.white,
                        size: 72), // Another Icon with white color
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

        Container(
          height: double.infinity,
          child: CameraPreview(_controller),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                child:ElevatedButton(
                      onPressed: (){}, 
                      child: Icon(Icons.camera)
                    
                ), 
              ),
            )
            

          ],
          )

      ]),
     

    );
  }
}
