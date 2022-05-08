import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qmate/authentication_services/auth_services.dart';

class RegisterAuth extends StatefulWidget {
  final Function toggleScreen;
  const RegisterAuth({required this.toggleScreen});

  @override
  _RegisterAuthState createState() => _RegisterAuthState();
}

class _RegisterAuthState extends State<RegisterAuth> {
  //step 1
  TextEditingController _nameController = TextEditingController();
  TextEditingController _firstPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _secondPasswordController = TextEditingController();

  //step 2
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contactsController = TextEditingController();

  //step 3
  TextEditingController _roleController = TextEditingController();

  //dropdown
  var selectedCurrency, selectedType;
  List<String> _accountType = <String>['user', 'qmate'];

  int _currentStep = 0;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _contactsController = TextEditingController();
    _locationController = TextEditingController();
    _firstPasswordController = TextEditingController();
    _secondPasswordController = TextEditingController();
    _roleController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _firstPasswordController.dispose();
    _secondPasswordController.dispose();
    _locationController.dispose();
    _contactsController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        child: Text("Register"),
                        maxRadius: 60,
                        backgroundColor: Colors.green,
                      ),
                      const Text(
                        "Register to Qmate",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      if (loginProvider.errorMessage != "")
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(loginProvider.errorMessage),
                              leading: const Icon(Icons.error),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => loginProvider.setMessage(""),
                              ),
                            )),
                    ],
                  ),
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
              maxChildSize: 1,
              minChildSize: .5,
              initialChildSize: .6,
              builder: (ctx, controller) {
                return Container(
                  //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: SingleChildScrollView(
                      controller: controller,
                      child: Form(
                        key: _formkey,
                        child: loginProvider.isLoading
                            ? const Padding(
                                padding: EdgeInsets.only(top: 200),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stepper(
                                    physics: const BouncingScrollPhysics(),
                                    steps: _mySteps(),
                                    currentStep: _currentStep,
                                    onStepTapped: (step) {
                                      setState(() {
                                        _currentStep = step;
                                      });
                                    },
                                    onStepContinue: () {
                                      setState(() {
                                        if (_currentStep <
                                            _mySteps().length - 1) {
                                          _currentStep = _currentStep + 1;
                                        } else {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            if (_firstPasswordController.text
                                                    .trim() ==
                                                _secondPasswordController.text
                                                    .trim()) {
                                              loginProvider.registerNewUsers(
                                                role: selectedType,
                                                name:
                                                    _nameController.text.trim(),
                                                email: _emailController.text
                                                    .trim(),
                                                password:
                                                    _firstPasswordController
                                                        .text
                                                        .trim(),
                                              );
                                            } else {
                                              const snackBar = SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                      "The two passwords do not match"));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                            //print(_roleController.text);
                                          }
                                        }
                                      });
                                    },
                                    onStepCancel: () {
                                      setState(() {
                                        if (this._currentStep > 0) {
                                          this._currentStep =
                                              this._currentStep - 1;
                                        } else {
                                          this._currentStep = 0;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                      )),
                );
              }),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              onPressed: () => widget.toggleScreen(),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: const Text('Account Information'),
        content: firstStep(),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Contacts Information'),
        content: secondStep(),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Account Type'),
        content: lastStep(),
        isActive: _currentStep >= 2,
      )
    ];
    return _steps;
  }

  firstStep({validator, prefix, hintText}) {
    return Column(
      children: [
        TextFormField(
            controller: _nameController,
            validator: (val) => val!.length < 6 ? "* Name required" : null,
            decoration: InputDecoration(
                labelText: "Name",
                hintText: "Full Name",
                prefixIcon: const Icon(Icons.person_add_alt_1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: _emailController,
            validator: (val) =>
                val!.length < 6 ? "Please enter an email address" : null,
            decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                prefixIcon: const Icon(Icons.attach_email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: _firstPasswordController,
            obscureText: true,
            validator: (val) => val!.length < 6 ? "* Password required" : null,
            decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock_clock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: _secondPasswordController,
            validator: (val) =>
                val!.length < 6 ? "* Confirm password Required" : null,
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Confirm",
                hintText: "Confirm Password",
                prefixIcon: const Icon(Icons.vpn_key),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )))
      ],
    );
  }

  secondStep({validator, prefix, hintText}) {
    return Column(
      children: [
        TextFormField(
            controller: _locationController,
            validator: (val) => val!.length < 6 ? "* City/town Required" : null,
            decoration: InputDecoration(
                labelText: "Location",
                hintText: "City/Town/Village",
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            keyboardType: TextInputType.number,
            controller: _contactsController,
            validator: (val) => val!.length < 6 ? "* Contacts Required" : null,
            decoration: InputDecoration(
                labelText: "Contacts",
                hintText: "Contacts",
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
      ],
    );
  }

  lastStep({validator, prefix, hintText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          FontAwesomeIcons.moneyBill,
          size: 25.0,
          color: Color(0xff11b719),
        ),
        const SizedBox(width: 50.0),
        DropdownButton(
          items: _accountType
              .map((value) => DropdownMenuItem(
                    child: Text(
                      value,
                      style: const TextStyle(color: Color(0xff11b719)),
                    ),
                    value: value,
                  ))
              .toList(),
          onChanged: (selectedAccountType) {
            print('$selectedAccountType');
            setState(() {
              selectedType = selectedAccountType;
            });
          },
          value: selectedType,
          isExpanded: false,
          hint: const Text(
            'Choose Account Type',
            style: TextStyle(color: Color(0xff11b719)),
          ),
        )
      ],
    );
  }
}
