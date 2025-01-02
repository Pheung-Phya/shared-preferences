import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatelessWidget {
  final GetStorage storage = GetStorage();

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      final isLoggedIn = storage.read('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Get.offNamed('/home'); // Navigate to home if logged in
      } else {
        Get.offNamed('/login'); // Navigate to login if not logged in
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo or splash image
            Image.asset(
              'assets/logo.png', // Replace with your logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to MyApp', // Replace with your app name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.blue, // Customize progress indicator color
            ),
          ],
        ),
      ),
    );
  }
}
