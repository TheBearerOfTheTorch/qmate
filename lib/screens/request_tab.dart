import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        const SizedBox(
          height: 20,
        ),
        const Text(
          "My Queue request",
          style: TextStyle(fontSize: 30),
        ),
        const SizedBox(
          height: 10,
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
                        title: Text(data['office']),
                        subtitle: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(data['location']),
                          ],
                        ),
                        trailing: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color:
                                  data['accepted'] ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            })
      ],
    );
  }
}
