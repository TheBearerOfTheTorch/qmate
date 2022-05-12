import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qmate/authentication_services/auth_services.dart';
import 'package:qmate/models/submit_request.dart';

import 'authentication/loginAuth.dart';
import 'chat_screen.dart';

class QmateScreen extends StatefulWidget {
  const QmateScreen({Key? key}) : super(key: key);

  @override
  State<QmateScreen> createState() => _QmateScreenState();
}

class _QmateScreenState extends State<QmateScreen> {
  TextEditingController _idController = TextEditingController();

  //object
  SubmitRequest request = SubmitRequest();

  //variable
  bool loading = false;

  AuthServices authServices = AuthServices();

  //key
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qmate"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authServices.logout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Queue requests",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("requests").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Theres an unknown error"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Card(
                          child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text("Request ${data['office']} Queue"),
                                  content: Form(
                                    key: _key,
                                    child: SizedBox(
                                      height: 120,
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                //get to the chat screens
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChatScreen()),
                                                );
                                              },
                                              child: loading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : const Text("Accept"))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        title: Text(data['office']),
                        subtitle: Text(data['time']),
                        trailing: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color:
                                data['foundQmate'] ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ));
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
