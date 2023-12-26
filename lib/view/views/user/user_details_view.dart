import 'package:flutter/material.dart';

import '../../../model/user.dart';
import '../../../utils/dimensions.dart';

class UserDetailsView extends StatelessWidget {
  final User user;
  final VoidCallback? tapAction;

  const UserDetailsView({
    Key? key,
    required this.user,
    this.tapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: Dimensions.bigPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userDetailsRow(context, "Full Name", user.fullName),
                  userDetailsRow(context, "Address", user.address),
                  userDetailsRow(context, "Email", user.email),
                  userDetailsRow(context, "CIN", user.cin),
                  userDetailsRow(context, "Phone Number", user.phoneNumber),
                  userDetailsRow(context, "Age", user.age.toString()),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userDetailsRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
