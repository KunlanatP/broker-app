import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
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
    final isMobile = MediaQuery.of(context).size.width < 700;

    if (isMobile) {
      return Column(
        children: [
          AppTextField(
            controller: searchController,
            label: 'Search broker',
            hint: 'Type broker name',
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),
          AppDropdownField(
            label: 'Broker Type',
            value: selectedType,
            items: AppConstants.brokerTypes,
            onChanged: onTypeChanged,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: searchController,
            label: 'Search broker',
            hint: 'Type broker name',
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 220,
          child: AppDropdownField(
            label: 'Broker Type',
            value: selectedType,
            items: AppConstants.brokerTypes,
            onChanged: onTypeChanged,
          ),
        ),
      ],
    );
  }
}
