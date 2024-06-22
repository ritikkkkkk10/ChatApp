import 'dart:developer';

import 'package:chat_app/api/apis.dart'; // Import your APIs class
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isAnimate = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController(); // Assuming you have an about field

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  Future<void> _signUpPress() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Create a ChatUser object
      ChatUser newUser = ChatUser(
        image: '', // Add appropriate image URL or leave it empty
        name: _nameController.text.trim(),
        about: _aboutController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
        id: userCredential.user!.uid,
        isOnline: true,
        lastActive: DateTime.now().toIso8601String(),
        pushToken: '', // Add appropriate push token or leave it empty
        email: _emailController.text.trim(),
      );

      // Save ChatUser details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(newUser.toJson());

      log("Signed up: ${userCredential.user?.email}");

      // Navigate to HomeScreen and pass userCredential.user
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: userCredential.user!)),
        (route) => false,
      );
    } catch (e) {
      log("Error: $e");
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
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
                  onPressed: _signUpPress,
                  child: const Text('Sign Up'),
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
