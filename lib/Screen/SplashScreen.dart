import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfdemo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async => await notificationService.launchApp());
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          FlutterLogo()
        ],
      ),
    );
  }
}
