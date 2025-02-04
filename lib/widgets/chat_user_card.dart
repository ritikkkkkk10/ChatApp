import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child:InkWell(
        onTap:() {
          //for navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
      child: ListTile(
        leading:const CircleAvatar(child: Icon(CupertinoIcons.person)),
        title: Text(widget.user.name),
        subtitle: Text(widget.user.about, maxLines: 1),
        trailing: Text('12:00 PM'),
      ),
      ),
    );
  }
}