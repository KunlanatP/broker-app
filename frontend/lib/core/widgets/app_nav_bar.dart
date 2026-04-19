import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class AppNavBar extends StatelessWidget {
  final bool transparent;

  const AppNavBar({super.key, this.transparent = false});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final isBrokers = path == '/' || path.startsWith('/broker/');

    return Material(
      color: transparent ? Colors.transparent : AppColors.navBarBackground,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width > 900 ? 100 : 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          border: transparent
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.borderHairline),
                ),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () => context.go('/'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Woxa',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 700) ...[
              const Spacer(),
              _NavLink(
                label: 'Brokers',
                active: isBrokers,
                onTap: () => context.go('/'),
              ),
              _NavLink(label: 'Markets', active: false, onTap: () {}),
              _NavLink(label: 'Analysis', active: false, onTap: () {}),
              _NavLink(label: 'Education', active: false, onTap: () {}),
              const Spacer(),
            ] else
              const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, size: 22),
              color: Colors.white70,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined, size: 26),
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white54,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.navActiveUnderline
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
