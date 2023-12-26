import 'package:pdm/utils/dimensions.dart';
import 'package:pdm/utils/theme/theme_styles.dart';
import 'package:pdm/utils/user_session.dart';
import 'package:pdm/view/splash_screen.dart';
import 'package:pdm/view/tabs/other_tab_view.dart';
import 'package:pdm/view/tabs/profile_tab_view.dart';
import 'package:pdm/view/tabs/users_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/theme/theme_provider.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  // UI
  PageController pageController = PageController();

  int currentPage = 0;

  List<String> tabTitles = [
    "Profile",
    "Users",
    "Other tab 1",
    "Other tab 2",
  ];

  List<IconData> tabIcons = [
    Icons.person_outline,
    Icons.people_outline,
    Icons.more_horiz,
    Icons.more_horiz,
  ];

  List<IconData> tabIconsSelected = [
    Icons.person,
    Icons.people,
    Icons.more_horiz,
    Icons.more_horiz,
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      body: Row(
        children: [
          Container(
            color: Styles.surfaceTint,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: isSmallScreen ? 50 : 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Expanded(
                  child: NavigationRail(
                    backgroundColor: Styles.surfaceTint,
                    extended: !isSmallScreen,
                    onDestinationSelected: (int index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      setState(() => currentPage = index);
                    },
                    selectedIndex: currentPage,
                    destinations: List.generate(
                      tabIcons.length,
                      (index) => NavigationRailDestination(
                        icon: Icon(tabIcons[index]),
                        selectedIcon: Icon(tabIconsSelected[index]),
                        label: Text(tabTitles[index]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Styles.primaryColor.withOpacity(0.5),
          ),
          Expanded(child: _buildBodyWidget())
        ],
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          ProfileTabView(),
          UsersTabView(),
          OtherTabView(),
          OtherTabView(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    final themeProvider = Provider.of<DarkThemeProvider>(context);

    return AppBar(
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(tabIcons[currentPage]),
              const SizedBox(width: 15),
              Text(
                tabTitles[currentPage],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: themeProvider.darkTheme
                    ? const Icon(Icons.dark_mode_outlined)
                    : const Icon(Icons.light_mode_outlined),
                onPressed: () => {
                  themeProvider.darkTheme = !themeProvider.darkTheme,
                },
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(dangerColor),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                label: const Text("Logout"),
                icon: const Icon(Icons.logout),
                onPressed: () => UserSession.instance.resetUserSession().then(
                      (value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        (route) => false,
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
