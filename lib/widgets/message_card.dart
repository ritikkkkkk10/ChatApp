import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  //sender or another user message
  Widget _blueMessage() {

    //update last read message if sender and receiver are different
    if(widget.message.read.isNotEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width*.04, vertical: mq.height * .01),
            decoration: BoxDecoration(color:const Color.fromARGB(255, 221, 245, 255),
            border: Border.all(color: Colors.lightBlue),
            //making borders curved
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30)
            )),
            child: Text(widget.message.msg ,
            style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),

      ],
    );
  }

  //our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Row(
          children: [
            
            SizedBox(width: mq.width * .04),

            //double tick icon
            if(widget.message.read.isNotEmpty)
            const Icon(Icons.done_all_rounded, color: Colors.blue, size:20),

            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            )
            

            //read time
        
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width*.04, vertical: mq.height * .01),
            decoration: BoxDecoration(color:const Color.fromARGB(255, 218, 255, 176),
            border: Border.all(color: Colors.lightGreen),
            //making borders curved
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)
            )),
            child: Text(widget.message.msg ,
            style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ),

      ],
    );
  }
}