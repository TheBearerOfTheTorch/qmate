import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _sendController = TextEditingController();

  //variable
  String? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text(
            "Andreas Iithindi",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text("Qmate", style: TextStyle(color: Colors.white)),
          trailing: CircleAvatar(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              _sendController.text.isEmpty
                  ? Image.asset("assets/assert for chat background.png")
                  : Padding(
                      padding: const EdgeInsets.only(right: 14.0, top: 320),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: 200,
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.zero,
                                  topLeft: Radius.circular(15))),
                          child: Text(
                            _sendController.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
              _sendController.text.isEmpty
                  ? const SizedBox(
                      height: 210,
                    )
                  : const SizedBox(
                      height: 40,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _sendController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          data = _sendController.text;
                        });
                      },
                    ),
                    hintText: "Start a chat",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(37)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
