import 'dart:async';

import 'package:documind/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DocuMind",
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Timer(Duration(seconds: 6),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppMainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        body: Container(
          child: Image.asset('assets/images/splash.jpg',
            fit: BoxFit.cover,
            height: double.infinity,

          ),
        )
    );
  }
}
// First of all I have to connect my project with firebase.