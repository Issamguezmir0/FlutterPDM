import 'package:flutter/material.dart';

import '../../../api/utils/api_view_handler.dart';
import '../../../view_model/auth_view_model.dart';
import '../login_view.dart';

class ForgotThirdView extends StatefulWidget {
  final String phoneNumber;

  const ForgotThirdView({super.key, required this.phoneNumber});

  @override
  State<ForgotThirdView> createState() => _ForgotThirdViewState();
}

class _ForgotThirdViewState extends State<ForgotThirdView> {
  AuthViewModel authViewModel = AuthViewModel();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController passwordConfirmationTEController =
      TextEditingController();

  bool passwordIsInvisible = true;

  void resetPassword() {
    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => authViewModel.resetPassword(
        phoneNumber: widget.phoneNumber,
        plainPassword: passwordTEController.text,
      ),
      successFunction: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password successfully changed"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Enter new password",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Choose a strong password.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Password:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordTEController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      suffixIcon: IconButton(
                        icon: passwordIsInvisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () => setState(
                            () => passwordIsInvisible = !passwordIsInvisible),
                      ),
                      hintText: "Enter your password",
                    ),
                    obscureText: passwordIsInvisible,
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "Password must be at least 5 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Password Confirmation:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordConfirmationTEController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        suffixIcon: IconButton(
                          icon: passwordIsInvisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () => setState(
                              () => passwordIsInvisible = !passwordIsInvisible),
                        ),
                        hintText: "Type your password again"),
                    obscureText: passwordIsInvisible,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Field cannot be empty";
                      }

                      if (value != passwordTEController.text) {
                        return "Passwords do not match";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40)),
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          _keyForm.currentState!.save();
                          resetPassword();
                        }
                      },
                      child: const Text("Next"),
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
