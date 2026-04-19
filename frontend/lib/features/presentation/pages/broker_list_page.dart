import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debounce.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_shell.dart';
import '../blocs/broker_list/broker_list_bloc.dart';
import '../blocs/broker_list/broker_list_event.dart';
import '../blocs/broker_list/broker_list_state.dart';
import '../widgets/broker_card.dart';
import '../widgets/broker_filter_bar.dart';
import '../widgets/partner_cta_card.dart';

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

  static const double _gridSpacing = 20;

  double _gridChildAspectRatio(double cellWidth, double textScale) {
    if (cellWidth <= 0) return 0.65;
    const bottomBlock = 260.0;
    final imageHeight = cellWidth / 1.5;
    final mainAxisExtent = imageHeight + bottomBlock * textScale;
    return (cellWidth / mainAxisExtent).clamp(0.45, 1.6);
  }

  double _horizontalPadding(double viewportWidth) {
    if (viewportWidth >= 1000) return 100;
    if (viewportWidth >= 600) return 32;
    return 24;
  }

  int _columnsForWidth(double contentWidth) {
    if (contentWidth < 640) return 1;
    if (contentWidth < 1100) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return AppPageShell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final horizontal = _horizontalPadding(viewportWidth);
          final innerWidth = (viewportWidth - 2 * horizontal).clamp(
            0.0,
            double.infinity,
          );
          final cols = _columnsForWidth(innerWidth);
          final cellWidth = cols > 0
              ? (innerWidth - (cols - 1) * _gridSpacing) / cols
              : innerWidth;
          final gridAspectRatio = _gridChildAspectRatio(cellWidth, textScale);

          return Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 0),
            child: BlocBuilder<BrokerListBloc, BrokerListState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Institutional Brokers',
                                      style: displaySerif(
                                        context,
                                        fontSize: innerWidth > 700 ? 40 : 30,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Access global liquidity through our curated network of elite '
                                      'financial institutions and market makers.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                            height: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (innerWidth > 520) ...[
                                const SizedBox(width: 16),
                                OutlinedButton.icon(
                                  onPressed: () => context.go('/create'),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add broker'),
                                ),
                              ],
                            ],
                          ),
                          if (innerWidth <= 520) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => context.go('/create'),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add broker'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          BrokerFilterBar(
                            searchController: _searchController,
                            selectedType: _selectedType,
                            onSearchChanged: (_) => _debounce.run(_fetch),
                            onTypeChanged: (value) {
                              setState(() => _selectedType = value);
                              _fetch();
                            },
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                    if (state.status == BrokerListStatus.loading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppLoading(),
                      )
                    else if (state.status == BrokerListStatus.failure)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppErrorView(message: state.message),
                      )
                    else if (state.brokers.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppEmpty(message: 'No brokers found'),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                mainAxisSpacing: _gridSpacing,
                                crossAxisSpacing: _gridSpacing,
                                childAspectRatio: gridAspectRatio,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            if (index == state.brokers.length) {
                              return const PartnerCtaCard();
                            }

                            final broker = state.brokers[index];
                            return BrokerCard(
                              broker: broker,
                              onTap: () => context.go('/broker/${broker.slug}'),
                            );
                          }, childCount: state.brokers.length + 1),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
