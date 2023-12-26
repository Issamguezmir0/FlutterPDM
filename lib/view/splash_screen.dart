import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdm/view/widgets/loading_widget.dart';
import '../utils/theme/theme_styles.dart';
import '../utils/user_session.dart';
import 'auth/login_view.dart';
import 'main_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Future<bool> checkSessionFuture;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      UserSession.instance.loadUserSession().then((value) {
        UserSession.currentUser == null
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (Route<dynamic> route) => false,
              )
            : UserSession.instance.refreshUserSession().whenComplete(
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainView()),
                    (Route<dynamic> route) => false,
                  ),
                );
      }).catchError((error, stackTrace) {
        if (kDebugMode) print(stackTrace);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", width: 200, height: 200),
            const SizedBox(height: 30),
            const LoadingWidget(),
          ],
        ),
      ),
    );
  }
}
