import 'package:chat_app/constance.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatBubble extends StatelessWidget {
  ChatBubble({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: EdgeInsets.only(left: 16, right: 64, top: 9, bottom: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),

            bottomRight: Radius.circular(20),
          ),
          color: kPrimaryColor,

          // borderRadius: BorderRadius.circular(20),
        ),

        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

// ignore: must_be_immutable
class FriendChatBubble extends StatelessWidget {
  FriendChatBubble({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: EdgeInsets.only(right: 16, left: 64, top: 9, bottom: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),

            bottomLeft: Radius.circular(20),
          ),
          color: Color(0xff006D84),

          // borderRadius: BorderRadius.circular(20),
        ),

        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
