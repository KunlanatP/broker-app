import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/debounce.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../blocs/broker_list/broker_list_bloc.dart';
import '../blocs/broker_list/broker_list_event.dart';
import '../blocs/broker_list/broker_list_state.dart';
import '../widgets/broker_card.dart';
import '../widgets/broker_filter_bar.dart';

class BrokerListPage extends StatefulWidget {
  const BrokerListPage({super.key});

  @override
  State<BrokerListPage> createState() => _BrokerListPageState();
}

class _BrokerListPageState extends State<BrokerListPage> {
  final _searchController = TextEditingController();
  final _debounce = Debounce(milliseconds: 500);
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    context.read<BrokerListBloc>().add(const BrokerListFetched());
  }

  void _fetch() {
    context.read<BrokerListBloc>().add(
          BrokerListFetched(
            search: _searchController.text.trim(),
            type: _selectedType,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broker List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: () => context.go('/create'),
              child: const Text('Create Broker'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width > 1000 ? 40 : 16,
          vertical: 20,
        ),
        child: Column(
          children: [
            BrokerFilterBar(
              searchController: _searchController,
              selectedType: _selectedType,
              onSearchChanged: (_) {
                _debounce.run(_fetch);
              },
              onTypeChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
                _fetch();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<BrokerListBloc, BrokerListState>(
                builder: (context, state) {
                  if (state.status == BrokerListStatus.loading) {
                    return const AppLoading();
                  }

                  if (state.status == BrokerListStatus.failure) {
                    return AppErrorView(message: state.message);
                  }

                  if (state.brokers.isEmpty) {
                    return const AppEmpty(message: 'No brokers found');
                  }

                  return ListView.separated(
                    itemCount: state.brokers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final broker = state.brokers[index];

                      return BrokerCard(
                        broker: broker,
                        onTap: () => context.go('/broker/${broker.slug}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}