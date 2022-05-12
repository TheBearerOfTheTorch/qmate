import 'package:flutter/material.dart';
import 'package:qmate/authentication_services/auth_services.dart';

class VerifyEmail extends StatelessWidget {
  VerifyEmail({Key? key}) : super(key: key);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QMATE",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.logout();
              })
        ],
      ),
      body: const VerifyDisplay(),
    );
  }
}

class VerifyDisplay extends StatelessWidget {
  const VerifyDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.95),
                          // borderRadius: BorderRadius.only(
                          //   bottomLeft: Radius.circular(40),
                          //   bottomRight: Radius.circular(40),
                          // )
                        ),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, right: 30),
                          ),
                        ),
                      )
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Verify Email",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  child: Text("Verify"),
                                  maxRadius: 60,
                                  backgroundColor: Colors.green,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "We can not redirect you",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 23),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "Check your emails for the verification link",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          ],
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 280,
            ),
          ],
        ),
      ],
    );
  }
}
