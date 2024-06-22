
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {

      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white
      )
      );

   // Check if a user is already logged in
      User? user = APIs.auth.currentUser;
      if (user != null) {
        // Navigate to HomeScreen if user is already logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        );
      } else {
        // Navigate to StartScreen if no user is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StartScreen()),
        );
      }
    });
  }

 

 


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
          Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            right: mq.width * .25,
            child: Image.asset('images/chat1.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('MADE IN INDIA WITH 💙',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87
            ),)),
        ],
      ),
    );
  }
}
