import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final compact = w < 960;

    return Material(
      color: AppColors.surfaceFooter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w > 900 ? 100 : 24,
          vertical: 28,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderHairline)),
        ),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Woxa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(spacing: 16, runSpacing: 8, children: _footerLinks()),
                  const SizedBox(height: 16),
                  Text(
                    '© 2024 STERLING MIDNIGHT. ALL RIGHTS RESERVED.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white38,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Woxa',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        children: _footerLinks(),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '© 2026 STERLING MIDNIGHT. ALL RIGHTS RESERVED.',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white38,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _footerLinks() {
    const style = TextStyle(
      color: Colors.white54,
      fontSize: 11,
      letterSpacing: 0.8,
      fontWeight: FontWeight.w500,
    );
    return [
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('PRIVACY POLICY', style: style),
      ),
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('TERMS OF SERVICE', style: style),
      ),
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('RISK DISCLOSURE', style: style),
      ),
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('CONTACT', style: style),
      ),
    ];
  }
}
