import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SpinningImage(),
        ),
      ),
    );
  }
}

class SpinningImage extends StatefulWidget {
  @override
  _SpinningImageState createState() => _SpinningImageState();
}

class _SpinningImageState extends State<SpinningImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _currentVersion;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          setState(() {});
          _getVersion();
          await _checkForUpdate();
        }
      });
    _controller.forward();
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;

    print('Current app version: $_currentVersion');
  }

  // Future<void> _checkForUpdate() async {
  //   String newVersion = '1.1.0'; // El ile versiyon veriyoruz şuan canlısını çekemediğimiz için

  //   if (newVersion != _currentVersion) {
  //     _showUpdateDialog(newVersion);
  //   }
  // }

  Future<void> _checkForUpdate() async {
    String url =
        'https://play.google.com/store/apps/details?id=com.bkv.wireless_mobile_app';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      String newVersion = jsonResponse['version'];
      if (newVersion != _currentVersion) {
        _showUpdateDialog(newVersion);
      }
    }
  }

void _showUpdateDialog(String newVersion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200, // Set the background color here
          title: Column(
            children: <Widget>[
              Icon(Icons.warning_rounded),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('New version is available!'),
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.amber,
                width: 2.0, 
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(
              'A new version of the app is available! We have updated the deploy app to a new version ($newVersion). Please update to the new version before continuing, this is mandatory.',
              style: TextStyle(fontSize: 14, color: Colors.amber),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text(
                    "Download & Upgrade",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    const url =
                        'https://play.google.com/store/apps/details?id=com.microsoft.outlooklite';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Image.asset('assets/images/splash.png'),
          ),
        ),
        if (_controller.status == AnimationStatus.completed)
          Align(
            alignment: Alignment(0, 0.5),
            child: Text(
              'BKV!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}




// import 'package:http/http.dart' as http;
// import 'dart:convert';


  // Future<void> _checkForUpdate() async {
  //   String url = 'https://your-api.com/version'; //
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     String newVersion = jsonResponse['version'];
  //     if (newVersion != _currentVersion) {
  //       _showUpdateDialog(newVersion);
  //     }
  //   }
  // }







// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: SpinningImage(),
//         ),
//       ),
//     );
//   }
// }

// class SpinningImage extends StatefulWidget {
//   @override
//   _SpinningImageState createState() => _SpinningImageState();
// }

// class _SpinningImageState extends State<SpinningImage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {});
//       }
//     });

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }





//  TextButton(
//               child: Text("Close"),
//               onPressed: () async {
//                const url = 'https://play.google.com/store/apps/details?id=com.microsoft.outlooklite'; // Android için
    
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//               },
//             ),