import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/broker_detail/broker_detail_bloc.dart';
import '../blocs/broker_detail/broker_detail_event.dart';
import '../blocs/broker_detail/broker_detail_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';

class BrokerDetailPage extends StatefulWidget {
  final String slug;

  const BrokerDetailPage({super.key, required this.slug});

  @override
  State<BrokerDetailPage> createState() => _BrokerDetailPageState();
}

class _BrokerDetailPageState extends State<BrokerDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BrokerDetailBloc>().add(BrokerDetailFetched(widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Broker Detail')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width > 1000 ? 40 : 16,
          vertical: 24,
        ),
        child: BlocBuilder<BrokerDetailBloc, BrokerDetailState>(
          builder: (context, state) {
            if (state.status == BrokerDetailStatus.loading) {
              return const AppLoading();
            }

            if (state.status == BrokerDetailStatus.failure) {
              return AppErrorView(message: state.message);
            }

            final broker = state.broker;
            if (broker == null) {
              return const AppErrorView(message: 'Broker not found');
            }

            final isDesktop = width > 900;

            return SingleChildScrollView(
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _DetailContent(broker: broker),
                        ),
                        const SizedBox(width: 24),
                        Expanded(child: _DetailSidebar(broker: broker)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailSidebar(broker: broker),
                        const SizedBox(height: 20),
                        _DetailContent(broker: broker),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailSidebar extends StatelessWidget {
  final dynamic broker;

  const _DetailSidebar({required this.broker});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: broker.logoUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              broker.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Chip(label: Text(broker.brokerType.toUpperCase())),
          ],
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final dynamic broker;

  const _DetailContent({required this.broker});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(broker.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            _InfoRow(label: 'Slug', value: broker.slug),
            _InfoRow(label: 'Website', value: broker.website),
            _InfoRow(label: 'Logo URL', value: broker.logoUrl),
            _InfoRow(label: 'Broker Type', value: broker.brokerType),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
