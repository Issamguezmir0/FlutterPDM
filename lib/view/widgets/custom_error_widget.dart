import 'package:flutter/material.dart';

import '../../utils/theme/theme_styles.dart';

class CustomErrorWidget extends StatelessWidget {
  final Function? tapFunction;

  const CustomErrorWidget({super.key, this.tapFunction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: dangerColor, size: 40),
          const Text("Network error"),
          if (tapFunction != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () => tapFunction!(),
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(
                    Colors.transparent,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Styles.primaryColor,
                  ),
                ),
                child: const Text("Tap here to refresh"),
              ),
            )
        ],
      ),
    );
  }
}
