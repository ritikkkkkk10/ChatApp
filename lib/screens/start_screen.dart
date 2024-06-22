import 'dart:developer';

import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            width: mq.width * .5,
            right: isAnimate ? mq.width * .25 : -mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/chat1.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .02,
            right: mq.width * .02,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder:(_) => const LoginScreen()));},
                  style: ElevatedButton.styleFrom(
    fixedSize: const Size(200, 50), // Adjust width and height as needed
    // Other button styles
  ),
                  child:const Text('Login'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder:(_) => const SignUpScreen()));},
                  style: ElevatedButton.styleFrom(
    fixedSize: const Size(200, 50), // Adjust width and height as needed
    // Other button styles
  ),
                  child:const Text('Signup'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
