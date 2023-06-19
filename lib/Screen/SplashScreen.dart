import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfdemo/main.dart';

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
    Timer(const Duration(seconds: 2), () async{
      if(authInst.currentUser!= null) {
        await userRef.doc(authInst.currentUser!.uid).update({"socketId":socketHelper.socketId});
        createdUser =  await getUserFromUid(authInst.currentUser!.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
    );
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
