import 'package:flutter/material.dart';

import '../../../api/utils/api_view_handler.dart';
import '../../../view_model/auth_view_model.dart';
import 'forgot_third_view.dart';

class ForgotSecondView extends StatefulWidget {
  final String phoneNumber;

  const ForgotSecondView({super.key, required this.phoneNumber});

  @override
  State<ForgotSecondView> createState() => _ForgotSecondViewState();
}

class _ForgotSecondViewState extends State<ForgotSecondView> {
  AuthViewModel authViewModel = AuthViewModel();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final List<TextEditingController> resetCodeControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  void verifyResetCode() {
    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => authViewModel.verifyResetCode(
        phoneNumber: widget.phoneNumber,
        resetCode: resetCodeControllers.map((controller) => controller.text).join(),
      ),
      successFunction: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotThirdView(
            phoneNumber: widget.phoneNumber,
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
                    "Enter Reset Code",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please enter the reset code sent to your phone.",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "If you didn't receive the code, click the resend button.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                              (index) => SizedBox(
                            width: 50,
                            child: TextFormField(
                              controller: resetCodeControllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Please enter the reset code";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                      ),
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          _keyForm.currentState!.save();
                          verifyResetCode();
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
