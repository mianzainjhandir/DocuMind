
import 'package:documind/views/home/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<bool> logIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red);
      return false;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar("Success", "Logged in Successfully!", backgroundColor: Colors.green);

      // Fields Clear
      emailController.clear();
      passwordController.clear();

      // Navigate to Home
      Get.offAll(() => const MainNavigation());

      return true; // ✅ Login Success
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(), backgroundColor: Colors.red);
      return false; // ❌ Login Failed
    }
  }

}
