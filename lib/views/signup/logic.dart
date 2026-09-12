import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documind/views/home/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required!", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match!", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // 1. Create user in Firebase Auth
      print("Starting Auth registration...");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Auth Success: ${userCredential.user!.uid}");

      // 2. Save user data to Firestore in 'docUser' collection
      print("Starting Firestore data saving...");
      await _firestore.collection('docUser').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }).then((value) {
        print("Firestore Success: Document created");
      }).catchError((error) {
        print("Firestore Error Details: $error");
        throw error;
      });

      Get.snackbar("Success", "Account created successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      
      // Clear fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      
      // Navigate to Home
      Get.offAll(() => const MainNavigation());
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
