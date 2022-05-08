import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubmitRequest {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future submitRequest({
    name,
    location,
    office,
    contact,
    date,
    time,
  }) async {
    await firebaseFirestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("requests")
        .add({
      'fullname': name,
      'location': location,
      'office': office,
      'contact': contact,
      'accepted': false,
      'time': time,
      date: date
    }).then((value) async {
      await firebaseFirestore.collection("requests").add({
        'fullname': name,
        'location': location,
        'office': office,
        'contact': contact,
        'foundQmate': false,
        'userId': auth.currentUser!.uid,
        'time': time,
        'date': date,
        'timeStamp': DateTime.now().toLocal()
      });
    });
    return false;
  }
}
