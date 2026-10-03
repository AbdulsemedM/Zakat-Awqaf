import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/payer_only.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../bloc/cause_detail_bloc.dart';
import '../../data/models/cause.dart';
import '../widgets/cause_card.dart';
import '../widgets/cause_visuals.dart';
import 'causes_screen.dart';

class CauseDetailScreen extends StatefulWidget {
  const CauseDetailScreen({super.key, required this.causeId});

  final String causeId;

  @override
  State<CauseDetailScreen> createState() => _CauseDetailScreenState();
}

class _CauseDetailScreenState extends State<CauseDetailScreen> {
  final _bloc = getIt<CauseDetailBloc>();
  String? _lang;

  void _load() =>
      _bloc.add(CauseDetailRequested(id: widget.causeId, lang: _lang ?? 'en'));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = apiLang(context.contentLocale);
    if (lang != _lang) {
      _lang = lang;
      _load();
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CauseDetailBloc, CauseDetailState>(
      bloc: _bloc,
      builder: (context, state) {
        return switch (state) {
          CauseDetailLoaded(:final detail) => _CauseDetailView(detail: detail),
          CauseDetailLoading() => _MessageScaffold(
            title: l10n.causesTitle,
            child: const Center(child: CircularProgressIndicator()),
          ),
          CauseDetailNotFound() => _MessageScaffold(
            title: l10n.causesTitle,
            child: CausesMessage(
              icon: Icons.search_off_rounded,
              message: l10n.causeNotFound,
            ),
          ),
          CauseDetailFailed() => _MessageScaffold(
            title: l10n.causesTitle,
            child: CausesMessage(
              icon: Icons.cloud_off_outlined,
              message: l10n.causesLoadError,
              onRetry: _load,
            ),
          ),
        };
      },
    );
  }
}

class _MessageScaffold extends StatelessWidget {
  const _MessageScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ZakatPageHeader(title: title),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CauseDetailView extends StatelessWidget {
  const _CauseDetailView({required this.detail});

  final CauseDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.contentLocale;
    final scheme = Theme.of(context).colorScheme;
    final cause = detail.cause;
    final endsOn = cause.endsOn;
    final today = DateUtils.dateOnly(DateTime.now());
    final ended = endsOn != null && endsOn.isBefore(today);
    final body = (detail.body ?? cause.description ?? '').trim();
    final canPay = cause.acceptsZakat && !ended;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CauseBanner(cause: cause, l10n: l10n, iconSize: 30),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Color(0x66000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.25,
                            ),
                          ),
                          color: AppColors.goldLight,
                          icon: const BackButtonIcon(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            sliver: SliverList.list(
              children: [
                Text(
                  cause.title,
                  style: AppTypography.displayHeading(
                    fontSize: 24,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TagPill(label: cause.category.label(l10n)),
                    if (cause.region != null)
                      _InfoChip(
                        icon: Icons.place_outlined,
                        label: cause.region!,
                      ),
                    if (endsOn != null)
                      _InfoChip(
                        icon: Icons.event_outlined,
                        label: ended
                            ? l10n.causeEndedOn(formatCauseDate(locale, endsOn))
                            : l10n.causeEndsOn(formatCauseDate(locale, endsOn)),
                      ),
                  ],
                ),
                if (CauseProgressRow.hasContent(cause)) ...[
                  const SizedBox(height: 16),
                  PremiumCard(child: CauseProgressRow(cause: cause)),
                ],
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.causeAbout,
                    style: AppTypography.body(
                      fontSize: 16,
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body,
                    style: AppTypography.body(
                      fontSize: 14,
                      color: scheme.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),
                ],
                if (detail.images.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: detail.images.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            detail.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                CauseCategoryBackdrop(category: cause.category),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: canPay
          ? PayerOnly(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: GoldActionButton(
                    label: l10n.payZakatCause,
                    icon: Icons.volunteer_activism_outlined,
                    onPressed: () => context.push(
                      '/zakat/payment',
                      extra: ZakatPaymentArgs.forCause(cause),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.body(fontSize: 12, color: color)),
      ],
    );
  }
}
