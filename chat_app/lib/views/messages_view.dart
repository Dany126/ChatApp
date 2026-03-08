import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy("createdAt", descending: true)
      .snapshots();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        List<MessageModel> messagesList = [];
        for (var doc in snapshot.data!.docs) {
          messagesList.add(MessageModel.fromJson(doc.data()));
        }

        return ListView.builder(
          reverse: true,
          itemCount: messagesList.length,
          itemBuilder: (context, index) {
            MessageModel message = messagesList[index];
            bool isMe = message.senderEmail == currentUser;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isMe
                  ? ChatBubble(text: message.message)
                  : FriendChatBubble(text: message.message),
            );
          },
        );
      },
    );
  }
}
