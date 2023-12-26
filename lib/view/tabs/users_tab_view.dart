import 'package:flutter/material.dart';
import 'package:pdm/utils/dimensions.dart';
import 'package:pdm/utils/theme/theme_styles.dart';
import 'package:pdm/view/views/user/user_add_update_view.dart';
import 'package:pdm/view/views/user/user_details_view.dart';
import 'package:pdm/view/widgets/custom_error_widget.dart';
import 'package:pdm/view/widgets/loading_widget.dart';
import 'package:pdm/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../../api/response/status.dart';
import '../../../model/user.dart';

class UsersTabView extends StatefulWidget {
  const UsersTabView({Key? key}) : super(key: key);

  @override
  State<UsersTabView> createState() => _UsersTabViewState();
}

class _UsersTabViewState extends State<UsersTabView> {
  // API
  UserViewModel userViewModel = UserViewModel();

  // METHODS

  void loadData() {
    userViewModel.getAll();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _buildMainWidget(context),
          );
        },
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          padding: Dimensions.bigPadding,
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "List of users",
                      style: TextStyle(fontSize: 45),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => const UserAddUpdateView(),
                          ),
                        )
                        .then(
                          (value) => loadData(),
                        ),
                    child: const Text("New user"),
                  ),
                  const SizedBox(width: 30),
                  FilledButton(
                    onPressed: () => loadData(),
                    child: const Text("Refresh list"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (context) => userViewModel,
                child: Consumer<UserViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.apiResponse.status == Status.completed) {
                      return _buildUsersTableWidget();
                    } else if (viewModel.apiResponse.status == Status.loading) {
                      return const LoadingWidget();
                    } else {
                      return const CustomErrorWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTableWidget() {
    return Card(
      elevation: 5,
      child: ClipRect(
        child: Table(
          border: TableBorder.all(
              borderRadius: Dimensions.roundedBorderMedium,
              color: Colors.black.withOpacity(0.15)),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Styles.primaryColor,
                borderRadius: Dimensions.roundedBorderTopMedium,
              ),
              children: [
                _makeTitleTableRowWidget(text: "Full name"),
                _makeTitleTableRowWidget(text: "Address"),
                _makeTitleTableRowWidget(text: "Email"),
                _makeTitleTableRowWidget(text: "Cin"),
                _makeTitleTableRowWidget(text: "Phone number"),
                _makeTitleTableRowWidget(text: "Age"),
                _makeTitleTableRowWidget(text: "Actions"),
              ],
            ),
            for (User user in userViewModel.itemList) _buildUserTableRow(user)
          ],
        ),
      ),
    );
  }

  TableRow _buildUserTableRow(User user) {
    return TableRow(
      children: [
        _makeTableRowWidget(text: user.fullName),
        _makeTableRowWidget(text: user.address),
        _makeTableRowWidget(text: user.email),
        _makeTableRowWidget(text: user.cin),
        _makeTableRowWidget(text: user.phoneNumber),
        _makeTableRowWidget(text: user.age),
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserDetailsView(user: user),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      noticeColor.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.remove_red_eye, color: noticeColor),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => UserAddUpdateView(user: user),
                        ),
                      )
                      .then((value) => loadData()),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      warningColor.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: warningColor),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () => userViewModel.delete(id: user.id!).then(
                        (value) => loadData(),
                      ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      dangerColor.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: dangerColor),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () {
                    user.isBanned = !user.isBanned;
                    userViewModel.update(user: user).then(
                          (value) => loadData(),
                        );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      user.isBanned
                          ? dangerColor.withOpacity(0.3)
                          : successColor.withOpacity(0.3),
                    ),
                  ),
                  icon: Icon(
                    user.isBanned ? Icons.block : Icons.gpp_good,
                    color: user.isBanned ? dangerColor : successColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _makeTitleTableRowWidget({required String text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _makeTableRowWidget({required String? text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text("$text"),
      ),
    );
  }
}
