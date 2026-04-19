import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/platform/document_meta.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_shell.dart';
import '../../broker/domain/entities/broker.dart';
import '../blocs/broker_detail/broker_detail_bloc.dart';
import '../blocs/broker_detail/broker_detail_event.dart';
import '../blocs/broker_detail/broker_detail_state.dart';

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
  void dispose() {
    resetPageMeta();
    super.dispose();
  }

  Future<void> _openUrl(String raw) async {
    final uri = Uri.parse(raw);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return BlocConsumer<BrokerDetailBloc, BrokerDetailState>(
      listener: (context, state) {
        if (state.status == BrokerDetailStatus.success &&
            state.broker != null) {
          final b = state.broker!;
          final t = b.profile.tagline.trim();
          final snippet = t.length > 155 ? '${t.substring(0, 155)}…' : t;
          setPageMeta(title: '${b.name} · Woxa', description: snippet);
        }
      },
      builder: (context, state) {
        if (state.status == BrokerDetailStatus.loading) {
          return const AppPageShell(child: Center(child: AppLoading()));
        }

        if (state.status == BrokerDetailStatus.failure) {
          return AppPageShell(
            child: Center(child: AppErrorView(message: state.message)),
          );
        }

        final broker = state.broker;
        if (broker == null) {
          return const AppPageShell(
            child: Center(child: AppErrorView(message: 'Broker not found')),
          );
        }

        final isDesktop = width > 960;
        final horizontal = width > 1000 ? 100.0 : 24.0;

        return AppPageShell(
          overlayNavigation: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroHeader(
                  broker: broker,
                  horizontalPadding: horizontal,
                  onVisitWebsite: () => _openUrl(broker.website),
                  onDownloadProspectus: () =>
                      _openUrl(broker.profile.prospectusUrl),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 40, horizontal, 48),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _MainColumn(broker: broker),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: _SidebarColumn(
                                broker: broker,
                                onOpenUrl: _openUrl,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _SidebarColumn(broker: broker, onOpenUrl: _openUrl),
                            const SizedBox(height: 32),
                            _MainColumn(broker: broker),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Broker broker;
  final double horizontalPadding;
  final VoidCallback onVisitWebsite;
  final VoidCallback onDownloadProspectus;

  const _HeroHeader({
    required this.broker,
    required this.horizontalPadding,
    required this.onVisitWebsite,
    required this.onDownloadProspectus,
  });

  @override
  Widget build(BuildContext context) {
    final taglineRaw = broker.profile.tagline.trim();
    final tagline = taglineRaw.length > 220
        ? '${taglineRaw.substring(0, 220)}…'
        : taglineRaw;
    final width = MediaQuery.sizeOf(context).width;
    final heroHeight = width < 600 ? 480.0 : 620.0;
    final titleSize = width < 700 ? 36.0 : (width < 1100 ? 52.0 : 72.0);
    final padTop = MediaQuery.paddingOf(context).top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _HeroBackdrop(
                heroUrl: broker.profile.heroImageUrl.trim(),
                logoFallback: broker.logoUrl,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      const Color(0xFF050C1C).withValues(alpha: 0.94),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: width < 600 ? 36 : 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'INSTITUTIONAL GRADE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ...List.generate(
                    5,
                    (_) => const Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: Icon(
                        Icons.star_rounded,
                        color: Color(0xFFE8EEF9),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width < 600 ? 12 : 20),
              Text(
                broker.name,
                style: displaySerif(
                  context,
                  fontSize: titleSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width > 900
                      ? width * 0.45
                      : width - 2 * horizontalPadding,
                ),
                child: Text(
                  tagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: width < 600 ? 16 : 20,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: width < 600 ? 20 : 28),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  FilledButton(
                    onPressed: onVisitWebsite,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Visit Website',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onDownloadProspectus,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                      backgroundColor: Colors.black.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Download Prospectus',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: padTop + 6,
          left: 8,
          child: Material(
            color: Colors.black.withValues(alpha: 0.25),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  final String heroUrl;
  final String logoFallback;

  const _HeroBackdrop({
    required this.heroUrl,
    required this.logoFallback,
  });

  @override
  Widget build(BuildContext context) {
    if (heroUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: heroUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, _) => Container(color: const Color(0xFF050C1C)),
        errorWidget: (_, _, _) =>
            _FallbackHeroImage(logoFallback: logoFallback),
      );
    }
    return _FallbackHeroImage(logoFallback: logoFallback);
  }
}

class _FallbackHeroImage extends StatelessWidget {
  final String logoFallback;

  const _FallbackHeroImage({required this.logoFallback});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/broker_detail_hero.png',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (context, error, stackTrace) {
        return CachedNetworkImage(
          imageUrl: logoFallback,
          fit: BoxFit.cover,
          color: Colors.black.withValues(alpha: 0.55),
          colorBlendMode: BlendMode.darken,
          placeholder: (context, url) =>
              Container(color: const Color(0xFF050C1C)),
          errorWidget: (context, url, err) =>
              Container(color: const Color(0xFF050C1C)),
        );
      },
    );
  }
}

class _MainColumn extends StatelessWidget {
  final Broker broker;

  const _MainColumn({required this.broker});

  List<String> _descriptionBlocks() {
    final byBlank = broker.description
        .split(RegExp(r'\n\s*\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (byBlank.length >= 2) return byBlank;
    final t = broker.description.trim();
    if (t.length < 120) return [t];
    final mid = t.length ~/ 2;
    var cut = t.indexOf(' ', mid);
    if (cut < 0) cut = mid;
    return [t.substring(0, cut).trim(), t.substring(cut).trim()];
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _descriptionBlocks();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Sovereign Mandate',
          style: displaySerif(
            context,
            fontSize: 30,
            color: AppColors.titleText,
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          Text(
            blocks[i],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.7,
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, c) {
            final twoCol = c.maxWidth > 520;
            final regulation = _FeatureMiniCard(
              icon: Icons.shield_outlined,
              title: broker.profile.regulationTitle,
              subtitle: broker.profile.regulationBody,
            );
            final execution = _FeatureMiniCard(
              icon: Icons.speed_outlined,
              title: broker.profile.executionTitle,
              subtitle: broker.profile.executionBody,
            );
            if (!twoCol) {
              return Column(
                children: [regulation, const SizedBox(height: 14), execution],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: regulation),
                const SizedBox(width: 14),
                Expanded(child: execution),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        Text(
          'Available Markets',
          style: displaySerif(context, fontSize: 26, color: Colors.white),
        ),
        const SizedBox(height: 20),
        _MarketsGrid(markets: broker.profile.markets),
      ],
    );
  }
}

class _FeatureMiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureMiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderOnSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.45,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketsGrid extends StatelessWidget {
  final List<MarketStat> markets;

  const _MarketsGrid({required this.markets});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        Widget card(String label, String value) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1F3A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderOnSurface),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.42),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          );
        }

        if (c.maxWidth >= 960) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < markets.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: card(markets[i].label, markets[i].value),
                ),
              ],
            ],
          );
        }

        return SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: markets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final m = markets[index];
              return SizedBox(
                width: 132,
                child: card(m.label, m.value),
              );
            },
          ),
        );
      },
    );
  }
}

class _SidebarColumn extends StatelessWidget {
  final Broker broker;
  final Future<void> Function(String) onOpenUrl;

  const _SidebarColumn({required this.broker, required this.onOpenUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1F3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderOnSurface),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Metrics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 22),
              _PerformanceRow(
                label: 'AUM GROWTH (YOY)',
                value: broker.profile.metricAum,
                valueTrailing: const _MiniSparkline(),
              ),
              const SizedBox(height: 18),
              _PerformanceRow(
                label: 'LIQUIDITY ACCESS',
                value: broker.profile.metricLiquidity,
                valueCaption: 'Daily Average',
              ),
              const SizedBox(height: 18),
              _PerformanceRow(
                label: 'CLIENT RETENTION',
                value: broker.profile.metricRetention,
                valueCaption: 'H1 2024',
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('View Full Audit Report'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1F3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderOnSurface),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONTACT & DETAILS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.4,
                  color: Colors.white54,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 18),
              _ContactRow(
                icon: Icons.location_on_outlined,
                text: broker.profile.address,
              ),
              _ContactRow(
                icon: Icons.email_outlined,
                text: broker.profile.contactEmail,
              ),
              InkWell(
                onTap: () => onOpenUrl(broker.website),
                borderRadius: BorderRadius.circular(4),
                child: _ContactRow(
                  icon: Icons.language,
                  text: broker.profile.displayDomain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final String value;

  final String? valueCaption;

  final Widget? valueTrailing;

  const _PerformanceRow({
    required this.label,
    required this.value,
    this.valueCaption,
    this.valueTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.9,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if (valueTrailing != null) ...[
                  const SizedBox(width: 8),
                  valueTrailing!,
                ],
              ],
            ),
            if (valueCaption != null) ...[
              const SizedBox(height: 4),
              Text(
                valueCaption!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.38),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MiniSparkline extends StatelessWidget {
  const _MiniSparkline();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(40, 22), painter: _SparklinePainter());
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.65)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.95,
        size.width * 0.45,
        size.height * 0.15,
        size.width * 0.65,
        size.height * 0.45,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.65,
        size.width * 0.88,
        size.height * 0.35,
        size.width,
        size.height * 0.4,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.4, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
