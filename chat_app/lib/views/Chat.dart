import 'package:chat_app/constance.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/views/messages_view.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    'Messages',
  );
  String currentUser = FirebaseAuth.instance.currentUser!.email!;

  String? messageText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "LoginPage");
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,

        title: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Logo.png", height: 40),

              const Text(
                "Chat",
                style: TextStyle(
                  fontFamily: "Pacifico",
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesView()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: kPrimaryColor),
                  onPressed: () {
                    if (messageText != null &&
                        messageText!.trim().isNotEmpty &&
                        currentUser != null) {
                      messages.add({
                        'senderEmail': currentUser,
                        'message': messageText!.trim(),
                        'createdAt': DateTime.now(),
                      });
                      controller.clear();
                      messageText = null;
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
