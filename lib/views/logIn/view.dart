
import 'package:documind/views/logIn/logic.dart';
import 'package:documind/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final LogInController controller = Get.put(LogInController());
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    const Color indigoTheme = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Logo/Image resized to match the screenshot
              Image.asset(
                'assets/images/img.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              // App Title
              const Text(
                'DocuMind',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E), // Dark Blue
                ),
              ),
              const Text(
                'Document Management &\nKnowledge Base',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 50),
              // Welcome Text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign in to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Email Field using CustomTextField
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Email address',
                prefixIcon: Icons.email_outlined,
                focusColor: indigoTheme,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Password Field using CustomTextField
              CustomTextField(
                controller: controller.passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                focusColor: indigoTheme,
              ),
              const SizedBox(height: 10),
              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: indigoTheme,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: indigoTheme,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    controller.logIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: indigoTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
