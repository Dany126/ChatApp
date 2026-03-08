import 'package:chat_app/views/Chat.dart';
import 'package:chat_app/views/Login.dart';
import 'package:chat_app/views/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "LoginPage": (context) => LoginPage(),
        "RegisterPage": (context) => RegisterPage(),
        "ChatPage": (context) => ChatPage(),
      },
      debugShowCheckedModeBanner: false,
      home: user != null ? ChatPage() : LoginPage(),
    );
  }
}
