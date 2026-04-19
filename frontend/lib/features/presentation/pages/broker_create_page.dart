import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_page_shell.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../blocs/broker_create/broker_create_bloc.dart';
import '../blocs/broker_create/broker_create_event.dart';
import '../blocs/broker_create/broker_create_state.dart';

class BrokerCreatePage extends StatefulWidget {
  const BrokerCreatePage({super.key});

  @override
  State<BrokerCreatePage> createState() => _BrokerCreatePageState();
}

class _BrokerCreatePageState extends State<BrokerCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _brokerType;

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _slugValidator(String? value) {
    final base = _requiredValidator(value);
    if (base != null) return base;
    final v = value!.trim();
    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(v)) {
      return 'Use lowercase letters, numbers, and single hyphens only';
    }
    return null;
  }

  String? _urlValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || (!uri.hasScheme || !uri.hasAuthority)) {
      return 'Invalid URL';
    }

    return null;
  }

  void _discard() {
    _nameController.clear();
    _slugController.clear();
    _descriptionController.clear();
    _logoUrlController.clear();
    _websiteController.clear();
    setState(() => _brokerType = null);
    _formKey.currentState?.reset();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_brokerType == null || _brokerType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select broker type')),
      );
      return;
    }

    context.read<BrokerCreateBloc>().add(
      BrokerCreateSubmitted(
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: _logoUrlController.text.trim(),
        website: _websiteController.text.trim(),
        brokerType: _brokerType!,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return BlocListener<BrokerCreateBloc, BrokerCreateState>(
      listener: (context, state) {
        if (state.status == BrokerCreateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Broker created successfully')),
          );
          context.go('/');
        }

        if (state.status == BrokerCreateStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AppPageShell(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            width > 1000 ? 100 : 24,
            28,
            width > 1000 ? 100 : 24,
            48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderOnSurface),
                ),
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<BrokerCreateBloc, BrokerCreateState>(
                    builder: (context, state) {
                      final isDesktop = width > 800;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/');
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Submit Broker',
                                  style: displaySerif(context, fontSize: 28),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Provide institutional-grade details. All fields are required before submission.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 28),
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _nameController,
                                    label: 'BROKER NAME',
                                    hint: 'e.g. Sterling Capital Markets',
                                    validator: _requiredValidator,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AppTextField(
                                    controller: _slugController,
                                    label: 'SLUG',
                                    hint: 'sterling-capital-markets',
                                    validator: _slugValidator,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            AppTextField(
                              controller: _nameController,
                              label: 'BROKER NAME',
                              hint: 'e.g. Sterling Capital Markets',
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _slugController,
                              label: 'SLUG',
                              hint: 'sterling-capital-markets',
                              validator: _slugValidator,
                            ),
                          ],
                          const SizedBox(height: 20),
                          AppDropdownField(
                            label: 'BROKER TYPE',
                            value: _brokerType,
                            items: AppConstants.brokerTypes,
                            onChanged: (value) {
                              setState(() => _brokerType = value);
                            },
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 20),
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _logoUrlController,
                                    label: 'LOGO URL',
                                    hint:
                                        'https://assets.sterling.com/logo.png',
                                    validator: _urlValidator,
                                    prefixIcon: const Icon(
                                      Icons.image_outlined,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AppTextField(
                                    controller: _websiteController,
                                    label: 'WEBSITE',
                                    hint: 'https://sterlingmidnight.com',
                                    validator: _urlValidator,
                                    prefixIcon: const Icon(
                                      Icons.public,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            AppTextField(
                              controller: _logoUrlController,
                              label: 'LOGO URL',
                              hint: 'https://assets.sterling.com/logo.png',
                              validator: _urlValidator,
                              prefixIcon: const Icon(
                                Icons.image_outlined,
                                color: Colors.white38,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _websiteController,
                              label: 'WEBSITE',
                              hint: 'https://sterlingmidnight.com',
                              validator: _urlValidator,
                              prefixIcon: const Icon(
                                Icons.public,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          AppTextField(
                            controller: _descriptionController,
                            label: 'BROKER DESCRIPTION',
                            hint:
                                'Provide a comprehensive institutional overview…',
                            maxLines: 5,
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _discard,
                                  child: const Text('Discard draft'),
                                ),
                                AppButton(
                                  text: 'Submit Application',
                                  loading:
                                      state.status ==
                                      BrokerCreateStatus.loading,
                                  onPressed: _submit,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
