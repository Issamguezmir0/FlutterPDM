import 'package:flutter/material.dart';

import '../../utils/theme/theme_styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Styles.primaryColor,
      ),
    );
  }
}
