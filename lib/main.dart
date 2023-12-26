import 'package:pdm/utils/theme/theme_provider.dart';
import 'package:pdm/utils/theme/theme_styles.dart';
import 'package:pdm/view/splash_screen.dart';
import 'package:pdm/view/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

late BuildContext applicationContext;

// GLOBAL VARIABLES
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeProvider = DarkThemeProvider();

  void loadThemeSettings() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    loadThemeSettings();
  }

  @override
  Widget build(BuildContext context) {
    applicationContext = context;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (context, theme, child) {
          return GlobalLoaderOverlay(
            closeOnBackButton: true,
            useDefaultLoading: false,
            overlayOpacity: 0.4,
            overlayWidget: const LoadingWidget(),
            overlayWholeScreen: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeProvider.darkTheme, context),
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
