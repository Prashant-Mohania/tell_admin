import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tell_admin/service/service.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController catController = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Category"),
          ),
          body: isLoad
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: catController,
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                          decoration: const InputDecoration(
                            hintText: "Enter your Category",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    isLoad = true;
                                  });
                                  Service.addCategory(
                                          catController.text.toUpperCase())
                                      .then((value) {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(20),
                                        content: Text("Added Successfully"),
                                      ),
                                    );
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.pop(
                                          context, catController.text);
                                    });
                                  });
                                } on FirebaseException {
                                  setState(() {
                                    isLoad = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(20),
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
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(20),
                                      content: Text("Error"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Add"))
                      ],
                    ),
                  ),
                )),
    );
  }
}
