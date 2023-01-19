import 'package:flutter/material.dart';
import 'package:networking_http/main_page.dart';
import 'firebase_options.dart';
import 'networking_http.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(NetworkSTL());
}

// void main() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(NetworkSTL());
// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MainPage();
//   }
// }
