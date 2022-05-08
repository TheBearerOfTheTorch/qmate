import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestTab extends StatefulWidget {
  const RequestTab({Key? key}) : super(key: key);

  @override
  State<RequestTab> createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("My Queue request"),
        const SizedBox(
          height: 40,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .collection("requests")
                .snapshots(),
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

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(data['office']),
                      subtitle: Text(data['location']),
                      trailing: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: data['accepted'] ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  );
                }).toList(),
              );
            })
      ],
    );
  }
}
