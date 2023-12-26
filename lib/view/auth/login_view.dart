import 'package:pdm/view/auth/forgot_password/forgot_first_view.dart';
import 'package:pdm/view/auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/utils/api_view_handler.dart';
import '../../utils/theme/theme_styles.dart';
import '../../utils/user_session.dart';
import '../../view_model/auth_view_model.dart';
import '../main_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // API
  AuthViewModel authViewModel = AuthViewModel();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  late TextEditingController emailTFController = TextEditingController();
  late TextEditingController passwordTFController = TextEditingController();

  bool passwordIsInvisible = true;

  void login() {
    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => authViewModel.login(
          email: emailTFController.text.toLowerCase(),
          password: passwordTFController.text),
      successFunction: () => UserSession.instance
          .saveUserSession(authViewModel.apiResponse.data!)
          .then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainView()),
              (Route<dynamic> route) => false,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent),
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _keyForm,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 400,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 150),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailTFController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordTFController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: passwordIsInvisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () => setState(() =>
                                passwordIsInvisible = !passwordIsInvisible),
                          ),
                          hintText: "Your Password",
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
                      const SizedBox(height: 50),
                      FilledButton(
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            _keyForm.currentState!.save();
                            login();
                          }
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
                            Text("Login"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Need an account?"),
                          TextButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterView()),
                              (Route<dynamic> route) => false,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(
                                  Styles.primaryColor),
                            ),
                            child: const Text("Register"),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Forgot password ?"),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotFirstView(),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(
                                  Styles.primaryColor),
                            ),
                            child: const Text("Reset password"),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
