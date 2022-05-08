import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../authentication_services/auth_services.dart';
import '../models/submit_request.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  AuthServices auth = AuthServices();
  SubmitRequest request = SubmitRequest();

  //controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _anotherDateController = TextEditingController();
  final TextEditingController timeCtl = TextEditingController();

  //variable
  bool loading = false;
  var date;
  int currentIndex = 0;

  //form state
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required field";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _locationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required field";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Enter location to queue",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _officeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required field";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Enter the office or field",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _contactController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required field";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Number qmate to contact you",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  validator: (val) =>
                      val!.isNotEmpty ? null : "Please select date",
                  controller: _anotherDateController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.calendarDay,
                    ),
                    hintText: 'Select your book date',
                    labelText: 'Date',
                  ),
                  onTap: () async {
                    final initialDate = DateTime.now();
                    var nedate = await showDatePicker(
                        context: context,
                        initialDate: date ?? initialDate,
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 1));

                    if (nedate == null) return;

                    setState(() {
                      date = nedate;
                    });
                    _anotherDateController.text =
                        date.toString().substring(0, 10);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: timeCtl, // add this line.
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.userClock,
                    ),
                    hintText: 'Select your book time',
                    labelText: 'Time',
                  ),
                  onTap: () async {
                    TimeOfDay time = TimeOfDay.now();
                    FocusScope.of(context).requestFocus(FocusNode());

                    TimeOfDay? picked = await showTimePicker(
                        context: context, initialTime: time);
                    if (picked != null && picked != time) {
                      timeCtl.text = picked.toString(); // add this line.
                      setState(() {
                        time = picked;
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'cant be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });

                        bool check = await request.submitRequest(
                            name: _nameController.text,
                            location: _locationController.text,
                            office: _officeController.text,
                            contact: _contactController.text,
                            date: _anotherDateController.text,
                            time: timeCtl.text);

                        setState(() {
                          loading = check;
                        });
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("submit request"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
