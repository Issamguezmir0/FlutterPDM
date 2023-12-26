import 'package:flutter/material.dart';
import 'package:pdm/api/utils/api_view_handler.dart';
import 'package:pdm/utils/user_session.dart';
import 'package:pdm/view_model/user_view_model.dart';

import '../../../model/user.dart';

class UserAddUpdateView extends StatefulWidget {
  final User? user;

  const UserAddUpdateView({
    super.key,
    this.user,
  });

  @override
  State<UserAddUpdateView> createState() => _UserAddUpdateViewState();
}

class _UserAddUpdateViewState extends State<UserAddUpdateView> {
  // API
  UserViewModel userViewModel = UserViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameTFController = TextEditingController();
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController phoneNumberTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();
  final TextEditingController passwordConfirmationTFController =
      TextEditingController();
  final TextEditingController addressTFController = TextEditingController();
  final TextEditingController cinTFController = TextEditingController();
  final TextEditingController ageTFController = TextEditingController();

  bool passwordIsInvisible = true;

  void addOrUpdate() {
    User user = User(
      id: widget.user?.id,
      fullName: fullNameTFController.text,
      address: addressTFController.text,
      email: emailTFController.text.toLowerCase(),
      cin: cinTFController.text,
      phoneNumber: phoneNumberTFController.text,
      age: ageTFController.text,
    );

    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => widget.user?.id == null
          ? userViewModel.add(
              user: user,
              plainPassword: passwordTFController.text,
            )
          : userViewModel.update(user: user),
      successFunction: () {
        if (user.id == UserSession.currentUser?.id) {
          UserSession.currentUser = user;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.user?.id == null
                  ? "User successfully added"
                  : "User successfully updated",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pop();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.user?.id != null) {
      fullNameTFController.text = widget.user?.fullName ?? "";
      emailTFController.text = widget.user?.email ?? "";
      phoneNumberTFController.text = widget.user?.phoneNumber ?? "";
      addressTFController.text = widget.user?.address ?? "";
      cinTFController.text = widget.user?.cin ?? "";
      ageTFController.text = widget.user?.age ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user?.id == null ? "Create user" : "Update user"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      widget.user?.id == null ? "Create user" : "Update user",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: const Text(
                      "Please fill the input below",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: fullNameTFController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Your full name",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter your full name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailTFController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email_outlined),
                      hintText: "Your Email",
                    ),
                    validator: (String? value) {
                      RegExp emailRegex = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                      );
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Invalid email address";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: addressTFController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: "Your Address",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter your address";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: cinTFController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.credit_card_outlined),
                      hintText: "Your CIN",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter your CIN";
                      }
                      double? number = double.tryParse(value);
                      if (number == null) {
                        return "CIN must contain only numbers";
                      }
                      if (value.length != 8) {
                        return "CIN must have 8 numbers";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumberTFController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Your Phone Number",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter your phone number";
                      }
                      double? number = double.tryParse(value);
                      if (number == null) {
                        return "Phone number must contain only numbers";
                      }
                      if (value.length != 8) {
                        return "Phone number must have 8 numbers";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: ageTFController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      hintText: "Your Age",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter your age";
                      } else {
                        return null;
                      }
                    },
                  ),
                  if (widget.user == null) const SizedBox(height: 20),
                  if (widget.user == null)
                    TextFormField(
                      controller: passwordTFController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        suffixIcon: IconButton(
                          icon: passwordIsInvisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () => setState(
                            () => passwordIsInvisible = !passwordIsInvisible,
                          ),
                        ),
                        hintText: "Your password",
                      ),
                      obscureText: passwordIsInvisible,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  if (widget.user == null) const SizedBox(height: 20),
                  if (widget.user == null)
                    TextFormField(
                      controller: passwordConfirmationTFController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        suffixIcon: IconButton(
                          icon: passwordIsInvisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () => setState(
                            () => passwordIsInvisible = !passwordIsInvisible,
                          ),
                        ),
                        hintText: "Confirm your password",
                      ),
                      obscureText: passwordIsInvisible,
                      validator: (String? value) {
                        if (value != passwordTFController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      },
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) addOrUpdate();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(widget.user?.id == null ? "Add" : "Update"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
