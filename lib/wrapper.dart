import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qmate/screens/authentication/authentication.dart';
import 'package:qmate/screens/authentication/verifyEmaile.dart';
import 'package:qmate/screens/home.dart';
import 'package:qmate/screens/qmate_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String role = 'client';
  bool isToggle = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("user : $user");
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData) {
            if (user != null) {
              if (!user.emailVerified) {
                //print(user);
                return VerifyEmail();
              } else {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        //print(user);
                        checkingRole(user.uid);
                      }
                      if (snapshot.hasError) {
                        return const Text("An unknown error has occured !");
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {}
                      return const Center(child: CircularProgressIndicator());
                    });
              }
            }
          }
          return Authentication();
        });
  }

  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  checkingRole(user) async {
    if (user != null) {
      final DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection("users").doc(user).get();

      setState(() {
        role = snap['role'];
      });

      if (role == 'qmate') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const QmateScreen()));
      }

      if (role == 'user') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    }
    return Authentication();
  }
}
