import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmate/screens/request_tab.dart';

import '../authentication_services/auth_services.dart';
import 'authentication/loginAuth.dart';
import 'home_tab.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final tabs = [const RequestTab(), const HomeTab()];

  AuthServices loginAuth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qmate"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await loginAuth.logout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(child: tabs[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_outlined),
              activeIcon: Icon(Icons.queue),
              label: "")
        ],
      ),
    );
  }
}
