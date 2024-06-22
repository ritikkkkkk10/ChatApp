import 'package:chat_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 // ignore: depend_on_referenced_packages
import 'firebase_options.dart';

//global object for accessing device screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //helps in fullscreen, orientations etc
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  

  runApp(const MyApp());
  await Future.delayed(Duration(seconds: 1));

  // Call the function to add name to Firestore
  await addNameToFirestore();
}

Future<void> addNameToFirestore() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Add 'ritik' to a collection named 'users'
    await firestore.collection('users').doc('Rotik').set({
      'name': 'Ritik',
    });

    print('Name added to Firestore!');
  } catch (e) {
    print('Error adding name to Firestore: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Chat',
        theme: ThemeData(
            appBarTheme:const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 19,
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            ),
        home: const SplashScreen(),
        );
  }
}
