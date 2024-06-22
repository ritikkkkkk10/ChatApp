
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //for storing all users
  List<ChatUser> list = [];

  //for storing searched items
  final List<ChatUser> searchList = [];

  //for storing search status
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getselfinfo();
  }

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
      //hide keyboard on tap screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          }else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: isSearching? TextField(
              decoration:const InputDecoration(
                border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                //when search text changes then update search list
                onChanged: (val) {
                  //search logic
                  searchList.clear();
        
                  for(var i in list) {
                    if(i.name.toLowerCase().contains(val.toLowerCase()) ||
                     i.email.toLowerCase().contains(val.toLowerCase())) {
                      searchList.add(i);
                     }
                     setState(() {
                       searchList;
                     });
                  }
                },
              )
             : const Text('We Chat'),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              }, icon: Icon(isSearching? CupertinoIcons.clear_circled_solid  : Icons.search)),
              IconButton(onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileScreen(users: APIs.me!)));
              }, icon: const Icon(Icons.more_vert)), // Sign out button
            ],
          ),
            body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
        
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
        
                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
        
                  if(list.isNotEmpty) {
              return ListView.builder (
                itemCount:isSearching? searchList.length : list.length,
                padding: EdgeInsets.only(top: mq.height * .02),
                itemBuilder: (context, index) {
                  return ChatUserCard(user: 
                  isSearching ? searchList[index] : list[index]);
                  // return  Text('Name: ${list[index]}');
                });
                }else {
                  return const Center(
                    child: Text('No Connections Found!',
                    style: TextStyle(fontSize: 20)),
                  );
                }
                }
              },
            ),
              floatingActionButton: Padding( 
        
            padding:const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: _signOut, 
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
        ),
      ),
    );
  }
}