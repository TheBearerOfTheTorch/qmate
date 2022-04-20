import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _resetController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset password"),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
                bottomLeft: Radius.circular(60),
              ),
              color: Colors.green,
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/cleanLogo.jpg"),
                      maxRadius: 60,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 5,
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: TextFormField(
                      controller: _resetController,
                      validator: (val) =>
                          val!.length < 6 ? "Email to reset password" : null,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await _auth.sendPasswordResetEmail(
                            email: _resetController.text.trim());

                        setState(() {
                          isLoading = false;
                        });
                        const snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                "A password reset link was sent to your email"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    height: 60,
                    minWidth: double.minPositive,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "Send Reset password link",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
