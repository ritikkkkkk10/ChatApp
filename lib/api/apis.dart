import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {

  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for storing self information
  static ChatUser? me;
  
  static User get user => auth.currentUser!;

  //for checking if the user exists or not
  static Future<bool> userExists() async {
    return (await firestore
    .collection('users')
    .doc(user.uid)
    .get())
    .exists;
  }

    //for getting current user info
  static Future<void> getselfinfo() async {
    await firestore
    .collection('users')
    .doc(user.uid)
    .get()
    .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getselfinfo());
      }
    });
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      about: "Hey there!!",
      email: user.email.toString(),
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: ''
    );

    return await firestore
    .collection('users')
    .doc(user.uid)
    .set(chatUser.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllUsers() {
    return APIs.firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }


//for updating user information
    static Future<void> updateUserInfo() async {
    await firestore
    .collection('users')
    .doc(user.uid)
    .update({
      'name' : me?.name,
      'about' : me?.about,
    });
  }

  //useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
  ? '${user.uid}_$id'
  : '${id}_${user.uid}';

    // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllMessages(
    ChatUser user) {
    return firestore
    .collection('chats/${getConversationID(user.id)}/messages/')
    .snapshots();
  }
   //for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
  try {
    // Message sending time (also used as ID)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Message to send
    final Message message = Message(
      msg: msg,
      toId: chatUser.id,
      read: '',
      type: Type.text, // Ensure type is correctly set
      fromId: user.uid,
      sent: time,
    );

    // Generate the Firestore path
    final path = 'chats/${getConversationID(chatUser.id)}/messages/';
    print('Generated path: $path');

    // Reference to Firestore collection
    final ref = firestore.collection(path);

    // Set the document with the message data
    await ref.doc(time).set(message.toJson());

    print("Message sent successfully");
  } catch (e) {
    print("Failed to send message: $e");
  }
}
//update read status of message
static Future<void> updateMessageReadStatus(Message message) async {
  firestore.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent).update({'read': DateTime.now().millisecondsSinceEpoch.toString()});

}
  

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)
}

