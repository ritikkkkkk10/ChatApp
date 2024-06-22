import 'dart:developer';

import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Fetch the user from userCredential
      User? user = userCredential.user;

      if (user != null) {
        log("Signed in: ${user.email}");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
          (route) => false,
        );
      } else {
        log("User is null");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: const Text('Failed to sign in. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log("Error: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: Text('Failed to sign in: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
