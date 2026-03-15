import 'package:flutter/material.dart';

import 'license_controller.dart';
import 'pro_screen.dart';

class ProGate extends StatelessWidget {
  const ProGate({super.key, required this.controller, required this.child});

  final LicenseController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.isProActive) return child;
        return ProScreen(controller: controller);
      },
    );
  }
}
