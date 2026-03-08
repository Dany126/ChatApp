// ignore: file_names
import 'package:chat_app/constance.dart';
import 'package:chat_app/helper/TextFormValidation.dart';
import 'package:chat_app/widgets/CustomButton.dart';
import 'package:chat_app/helper/CustomSnackBar.dart';
import 'package:chat_app/widgets/CustomTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String id = 'Register Page';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                    "Register",
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
                    text: "Register",

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          var User = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              );
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(User.user!.uid)
                              .set({
                                'email': email,
                                'password': password,
                                'uid': User.user!.uid,
                                'createdAt': DateTime.now(),
                                'updatedAt': DateTime.now(),
                              });
                          isLoading = false;
                          setState(() {});
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, "ChatPage");
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          if (e.code == 'weak-password') {
                            customSnackBar(
                              context,
                              'The password provided is too weak.',
                              Colors.red,
                            );
                          } else if (e.code == 'email-already-in-use') {
                            customSnackBar(
                              context,
                              'The account already exists for that email.',
                              Colors.red,
                            );
                          }
                        } catch (e) {
                          customSnackBar(context, e.toString(), Colors.red);
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
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
