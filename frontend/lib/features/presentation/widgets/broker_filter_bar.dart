import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';

class BrokerFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;

  const BrokerFilterBar({
    super.key,
    required this.searchController,
    required this.selectedType,
    required this.onSearchChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: searchController,
          label: 'Search',
          hint: 'Find brokers by name, region, or asset class…',
          prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 22),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 20),
        Text(
          'ASSET FOCUS:',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: Colors.white54,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TypePill(
              label: 'All Partners',
              selected: selectedType == null,
              filled: selectedType == null,
              onTap: () => onTypeChanged(null),
            ),
            ...AppConstants.brokerTypes.map(
              (t) => _TypePill(
                label: t.toUpperCase(),
                selected: selectedType == t,
                filled: selectedType == t,
                onTap: () => onTypeChanged(t),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypePill extends StatelessWidget {
  final String label;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  const _TypePill({
    required this.label,
    required this.selected,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: filled ? AppColors.accent : AppColors.pillInactiveBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? AppColors.accent
                  : Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: filled ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
