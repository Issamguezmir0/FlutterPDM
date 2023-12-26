import 'package:pdm/utils/theme/theme_styles.dart';
import 'package:pdm/utils/dimensions.dart';
import 'package:pdm/view/widgets/custom_error_widget.dart';
import 'package:pdm/view/widgets/loading_widget.dart';
import 'package:pdm/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/response/status.dart';
import '../../../model/user.dart';

class OtherTabView extends StatefulWidget {
  const OtherTabView({Key? key}) : super(key: key);

  @override
  State<OtherTabView> createState() => _OtherTabViewState();
}

class _OtherTabViewState extends State<OtherTabView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
