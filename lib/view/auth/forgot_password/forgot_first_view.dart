import 'package:pdm/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

import '../../../api/utils/api_view_handler.dart';
import 'forgot_second_view.dart';

class ForgotFirstView extends StatefulWidget {
  const ForgotFirstView({Key? key}) : super(key: key);

  @override
  State<ForgotFirstView> createState() => _ForgotFirstViewState();
}

class _ForgotFirstViewState extends State<ForgotFirstView> {
  AuthViewModel authViewModel = AuthViewModel();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController phoneNumberTFController = TextEditingController();

  void sendConfirmationCode() {
    String phoneNumber = phoneNumberTFController.text;

    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => authViewModel.forgotPassword(
        phoneNumber: phoneNumber,
      ),
      successFunction: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotSecondView(
            phoneNumber: phoneNumber,
          ),
        ),
      ),
      failureFunction: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotSecondView(
            phoneNumber: phoneNumber,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your phone number to reset your password.',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Enter your phone number',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberTFController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Your phone number',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 8) {
                        return 'Invalid phone number address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          _keyForm.currentState!.save();
                          sendConfirmationCode();
                        }
                      },
                      child: const Text('Next'),
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
