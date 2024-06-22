import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser users;
  
  const ProfileScreen({super.key, required this.users});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ChatUser user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add this line to define _formKey

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/'); // Navigate to start screen or login screen
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile Screen')),
      
        floatingActionButton: Padding( 
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Logout')),
        ),
        body: Form(
          key: _formKey, // Use _formKey here
          child: Column(
            children: [
              SizedBox(height: mq.height * .03, width: mq.width),
              Center(
                child: 
                Text(widget.users.email, 
                style: const TextStyle(color: Colors.black54, fontSize: 16))),
                 
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  initialValue: widget.users.name,
                  onSaved: (val) => APIs.me?.name = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    hintText: 'eg. Happy Singh',
                    label: const Text('Name'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  initialValue: widget.users.about,
                  onSaved: (val) => APIs.me?.about = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline),
                    border: const OutlineInputBorder(),
                    hintText: 'Sleeping',
                    label: const Text('About'),
                  ),
                ),
              ),
              SizedBox(height: mq.height * .02),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder(),
                  minimumSize: Size(mq.width * .4, mq.height * .055)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    APIs.updateUserInfo().then((value){
                      Dialogs.showSnackbar(
                        context, 'Profile Updated Successfully!'
                      );
                    } );
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
