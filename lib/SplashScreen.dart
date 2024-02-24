import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#8a76ba"),
      body: const Center(
        child: Image(
            image: AssetImage('assets/SplashScreenImg1.png')
        ),
      ),
    );
  }
}
