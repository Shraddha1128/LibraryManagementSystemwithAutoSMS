import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only once
  await Firebase.initializeApp(
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyDPOet4Z8Rth5LUoNJN1FulpG8jP09qX7c",
    //   authDomain: "autolibreply-2d34d.firebaseapp.com",
    //   projectId: "autolibreply-2d34d",
    //   storageBucket: "autolibreply-2d34d.firebasestorage.app",
    //   messagingSenderId: "631828263933",
    //   appId: "1:631828263933:web:b7826bb28615fed940df94",
    //   measurementId: "G-7P8M18HTG4",
    // ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Lib Reply',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const StartPage(),
    );
  }
}
