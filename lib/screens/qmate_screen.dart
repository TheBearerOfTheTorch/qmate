import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'authentication/loginAuth.dart';

class QmateScreen extends StatefulWidget {
  const QmateScreen({Key? key}) : super(key: key);

  @override
  State<QmateScreen> createState() => _QmateScreenState();
}

class _QmateScreenState extends State<QmateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qmate"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginAuth()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(child: Text("Queue requests")),
            const SizedBox(
              height: 50,
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
                return ListView(
                  scrollDirection: Axis.vertical,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Card(
                        child: ListTile(
                      title: Text(data['office']),
                      subtitle: Text(data['time']),
                      trailing: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: data['foundQmate'] ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ));
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
