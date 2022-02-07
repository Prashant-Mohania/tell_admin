// ignore_for_file: unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tell_admin/service/local_data.dart';
import '../HomePage/home_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoad = false;

  SharedPreferences? prefs;

  Future<void> initializePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: isLoad
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 40,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const Spacer(),
                          TextFormField(
                            controller: userIdController,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(
                              hintText: "Enter UserId",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passcodeController,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Enter Passcode",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoad = true;
                                });

                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: userIdController.text +
                                            "@teksna.com",
                                        password: passcodeController.text)
                                    .then((value) {
                                  initializePreference().whenComplete(() {
                                    prefs!.setBool("isLogin", true);
                                  });
                                  LocalData.setAuth(true);
                                  // LocalData.setLogin(true);
                                  setState(() {
                                    isLoad = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(20),
                                      content:
                                          Text("Authentication Successful"),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                }).catchError((e) {
                                  // ignore: avoid_print
                                  print(e);
                                  setState(() {
                                    isLoad = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(20),
                                      content: Text(e.message),
                                    ),
                                  );
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: const Text('Login', textScaleFactor: 2),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
