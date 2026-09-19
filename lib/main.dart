import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:documind/views/home/main_navigation.dart';
import 'package:documind/views/logIn/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "DocuMind",
      debugShowCheckedModeBanner: false,
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


    Timer(Duration(seconds: 4), () {
      // Check if user is already logged in with Firebase Auth persistence session
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // If user is already authenticated session token exists, navigate straight to Main Dashboard Home screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
      } else {
        // If no active auth session found, navigate to LogIn page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        body: Container(
          child: Image.asset('assets/images/splash1.jpg',
            fit: BoxFit.cover,
            height: double.infinity,

          ),
        )
    );
  }
}
//
// First of all I have to connect my project with firebase.
// install the git new version
// sjsjjs;;;
// lllpppp
//  I did nothing but i commiting this code for testing.