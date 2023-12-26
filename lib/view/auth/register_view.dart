import 'package:flutter/material.dart';
import '../../api/utils/api_view_handler.dart';
import '../../model/user.dart';
import '../../utils/theme/theme_styles.dart';
import 'login_view.dart';
import 'package:pdm/view_model/auth_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  AuthViewModel authViewModel = AuthViewModel();

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

  void register() {
    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => authViewModel.register(
        user: User(
          fullName: fullNameTFController.text,
          address: addressTFController.text,
          email: emailTFController.text.toLowerCase(),
          cin: cinTFController.text,
          phoneNumber: phoneNumberTFController.text,
          age: ageTFController.text,
        ),
        plainPassword: passwordTFController.text,
      ),
      successFunction: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful"),
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
      appBar: AppBar(title: const Text("Register")),
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
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                        if (_formKey.currentState!.validate()) register();
                      },
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                          Text("Sign Up"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                          (Route<dynamic> route) => false,
                        ),
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Colors.transparent,
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(Styles.primaryColor),
                        ),
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
