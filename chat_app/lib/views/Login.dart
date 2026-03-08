import 'dart:developer';

import 'package:chat_app/constance.dart';
import 'package:chat_app/helper/TextFormValidation.dart';
import 'package:chat_app/widgets/CustomButton.dart';
import 'package:chat_app/helper/CustomSnackBar.dart';
import 'package:chat_app/widgets/CustomTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool inAsyncCall = false;

  Future<void> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 60),

                  /// Logo
                  Image.asset("assets/images/Logo.png", height: 120),

                  const SizedBox(height: 10),

                  /// App Name
                  const Text(
                    "Scholar Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: "Pacifico",
                    ),
                  ),

                  const SizedBox(height: 60),

                  const Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  /// Email Field
                  CustomTextFormField(
                    hint: "Enter your email",
                    onChanged: (value) {
                      email = value;
                    },
                    validator: validateEmail,
                  ),

                  const SizedBox(height: 15),

                  /// Password Field
                  CustomTextFormField(
                    hint: "Enter your password",
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: validatePassword,
                  ),

                  const SizedBox(height: 30),

                  /// Login Button
                  CustomButton(
                    text: "Login",

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        inAsyncCall = true;
                        setState(() {});
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              );

                          // لو نجح
                          inAsyncCall = false;
                          setState(() {});
                          Navigator.pushReplacementNamed(context, "ChatPage");
                        } on FirebaseAuthException catch (e) {
                          inAsyncCall = false;
                          setState(() {});

                          if (e.code == 'user-not-found') {
                            customSnackBar(
                              context,
                              "No user found for that email.",
                              Colors.red,
                            );
                          } else if (e.code == 'wrong-password') {
                            customSnackBar(
                              context,
                              "Wrong password provided for that user.",
                              Colors.red,
                            );
                          } else {
                            customSnackBar(
                              context,
                              e.message ?? "Login failed",
                              Colors.red,
                            );
                          }
                        } catch (e) {
                          inAsyncCall = false;
                          setState(() {});
                          customSnackBar(context, e.toString(), Colors.red);
                          log(e.toString());
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "RegisterPage");
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
