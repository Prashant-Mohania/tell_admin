import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tell_admin/screen/AuthPage/auth_screen.dart';
import 'package:tell_admin/service/local_data.dart';
import 'package:tell_admin/service/service.dart';

import '../add_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cat = ["add Category"];
  //  = ["CS", "EC", "ME", "EE", "CE", "CH", "BT", "MCA"];

  TextEditingController urlController = TextEditingController();
  TextEditingController catController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoad = false;

  @override
  void initState() {
    Service.fetchCategorys().then((value) {
      for (var element in value.docs) {
        cat.add(element.data()["category"]);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
          actions: [
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  LocalData.setAuth(false);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()));
                },
                child: const Text("Sign Out"),
              ),
            ),
          ],
        ),
        body: isLoad
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: urlController,
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                        decoration: InputDecoration(
                          hintText: "Enter your Url",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              Clipboard.getData("text.plain").then((data) {
                                urlController.text = data!.text ?? "";
                              });
                            },
                            icon: const Icon(Icons.paste),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: catController,
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                        onTap: () async {
                          var res = await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cat.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(cat[index]),
                                      onTap: () {
                                        Navigator.pop(context, cat[index]);
                                      },
                                    );
                                  }),
                            ),
                          );
                          if (res == "add Category") {
                            var response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddCategory()));
                            if (response != null) {
                              catController.text =
                                  response.toString().toUpperCase();
                            }
                          } else if (res != null) {
                            catController.text = res;
                          }
                        },
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: "Select Category",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoad = true;
                                });
                                await Service.addUrlFeed(
                                    urlController.text, catController.text);
                                setState(() {
                                  urlController.text = "";
                                  catController.text = "";
                                  isLoad = false;
                                });
                              } on FirebaseException {
                                setState(() {
                                  isLoad = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error"),
                                  ),
                                );
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                                setState(() {
                                  isLoad = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error"),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text("Submit")),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
