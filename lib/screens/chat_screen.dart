import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //for storing messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: const Color.fromARGB(255, 234, 248, 255),

        body: Column(
          children: [


            Expanded(
              child: StreamBuilder(
                 stream: APIs.getAllMessages(widget.user),
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
                    //  log('Data: ${jsonEncode(data![0].data())}');
                    _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              
                    // final list = [];
                    // _list.clear();

                    // _list.add(Message(toId: 'xyz', msg: 'Hii', read: '', type: Type.text, fromId: APIs.user.uid, sent: '12:00 AM'));
                    // _list.add(Message(toId: APIs.user.uid, msg: 'Hii', read: '', type: Type.text, fromId: 'abc', sent: '12:00 AM'));
                      
                    if(_list.isNotEmpty) {
                return ListView.builder (
                  itemCount:_list.length,
                  padding: EdgeInsets.only(top: mq.height * .02),
                  itemBuilder: (context, index) {
                    return MessageCard(message: _list[index]);
                    // return  Text('Name: ${list[index]}');
                  });
                  }else {
                    return const Center(
                      child: Text('Say Hii!',
                      style: TextStyle(fontSize: 20)),
                    );
                  }
                  }
                },
              ),
            ),


            _chatInput()],
        ),
      ),
    );
  }
  Widget _appBar() {
    return InkWell(
      onTap:() {} ,
      child: Row(children: [
        //back button
        IconButton(onPressed: () => Navigator.pop(context), 
        icon: const Icon(Icons.arrow_back)),
      
        SizedBox(width: 5),
      
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            )),
            
            const Text('Last seen',
            style:  TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w300
            ))
          ],
        )
      ],
      ),
    );
}

//bottom chat input field
Widget _chatInput() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Row (children: [
      //emoji button
      IconButton(
        onPressed: () {}, 
          icon: const Icon(Icons.emoji_emotions)),
    
          Expanded(
          child: TextField(
            controller: _textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
            decoration:const InputDecoration(
              hintText: 'Type Something...',
              hintStyle: TextStyle(color: Colors.blueAccent),
              border: InputBorder.none
            ),
          )),



    
          MaterialButton(
            onPressed: () {
              if(_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size:20))
    ],),
  );
}
}

