import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../response/api_response.dart';
import '../response/status.dart';
import '../../utils/theme/theme_styles.dart';
import '../../utils/dimensions.dart';

class ApiViewHandler {
  static Future<bool> handleApiCallWithAlert({
    required BuildContext context,
    bool showIndicator = true,
    required Future<ApiResponse> Function() apiCall,
    required Function successFunction,
    Function? failureFunction,
  }) async {
    late bool isSuccess = false;
    if (showIndicator) context.loaderOverlay.show();
    await apiCall().then((apiResponse) {
      if (showIndicator) context.loaderOverlay.hide();
      if (apiResponse.status == Status.completed) {
        successFunction();
        isSuccess = true;
      } else {
        if (failureFunction != null) {
          failureFunction();
        } else {
          showSimpleAlertDialog(
            context: context,
            title: "Error",
            content: apiResponse.message,
            isDanger: true,
          );
        }
        isSuccess = false;
      }
    });
    return isSuccess;
  }

  static void showSimpleAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    bool isSuccess = false,
    bool isDanger = false,
    bool isWarning = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _customDialogBox(
          context: context,
          title: title,
          description: content,
          isSuccess: isSuccess,
          isDanger: isDanger,
          isWarning: isWarning,
        );
      },
    );
  }

  static Widget _customDialogBox({
    required BuildContext context,
    required String title,
    required String description,
    bool isSuccess = false,
    bool isDanger = false,
    bool isWarning = false,
    Widget? widget,
  }) {
    IconData icon;
    Color mainColor;

    if (isDanger) {
      mainColor = dangerColor;
      icon = Icons.error;
    } else if (isWarning) {
      mainColor = warningColor;
      icon = Icons.warning;
    } else if (isSuccess) {
      mainColor = successColor;
      icon = Icons.check_circle;
    } else {
      mainColor = noticeColor;
      icon = Icons.info;
    }

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: Dimensions.roundedBorderBig,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: Dimensions.bigPadding,
        decoration: BoxDecoration(
          color: Styles.primaryBackgroundColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget ??
                Column(
                  children: [
                    Icon(icon, size: 75, color: mainColor),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(description),
                    const SizedBox(height: 20),
                  ],
                ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: mainColor,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: Dimensions.roundedBorderMedium,
                        ),
                      ),
                    ),
                    child: const Text("Ok"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
