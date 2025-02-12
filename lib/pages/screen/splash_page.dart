import 'dart:async';
import 'package:budget_tracker/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Timer(
          const Duration(seconds: 3),
          () {
            Get.offNamed(GetPages.home);
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash_screen_image/image.png',
              height: 150,
            ),
            const SizedBox(height: 30),
            const Text(
              "My Awesome App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "The Best App for You!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
