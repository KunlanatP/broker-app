import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
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
    final width = MediaQuery.of(context).size.width;

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
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Broker')),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width > 900 ? 60 : 16,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<BrokerCreateBloc, BrokerCreateState>(
                      builder: (context, state) {
                        final isDesktop = width > 800;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Submit Broker Form',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (isDesktop)
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: _nameController,
                                      label: 'Name',
                                      validator: _requiredValidator,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      controller: _slugController,
                                      label: 'Slug',
                                      validator: _requiredValidator,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              AppTextField(
                                controller: _nameController,
                                label: 'Name',
                                validator: _requiredValidator,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _slugController,
                                label: 'Slug',
                                validator: _requiredValidator,
                              ),
                            ],
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _descriptionController,
                              label: 'Description',
                              maxLines: 4,
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 16),
                            if (isDesktop)
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: _logoUrlController,
                                      label: 'Logo URL',
                                      validator: _urlValidator,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      controller: _websiteController,
                                      label: 'Website',
                                      validator: _urlValidator,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              AppTextField(
                                controller: _logoUrlController,
                                label: 'Logo URL',
                                validator: _urlValidator,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _websiteController,
                                label: 'Website',
                                validator: _urlValidator,
                              ),
                            ],
                            const SizedBox(height: 16),
                            AppDropdownField(
                              label: 'Broker Type',
                              value: _brokerType,
                              items: AppConstants.brokerTypes,
                              onChanged: (value) {
                                setState(() {
                                  _brokerType = value;
                                });
                              },
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppButton(
                                text: 'Submit',
                                loading:
                                    state.status == BrokerCreateStatus.loading,
                                onPressed: _submit,
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
      ),
    );
  }
}
