import 'package:flutter/material.dart';

import 'app_footer.dart';
import 'app_nav_bar.dart';

class AppPageShell extends StatelessWidget {
  final Widget child;

  final bool overlayNavigation;

  const AppPageShell({
    super.key,
    required this.child,
    this.overlayNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    if (overlayNavigation) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.hardEdge,
                children: [
                  child,
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppNavBar(transparent: true),
                  ),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppNavBar(),
          Expanded(child: child),
          const AppFooter(),
        ],
      ),
    );
  }
}
