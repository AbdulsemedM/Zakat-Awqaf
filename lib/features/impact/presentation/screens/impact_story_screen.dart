import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../causes/presentation/screens/causes_screen.dart';
import '../../../causes/presentation/widgets/cause_visuals.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../bloc/impact_story_bloc.dart';
import '../../data/models/impact_model.dart';

/// One Baraka story (`GET /api/zakat/v1/impact/stories/{id}`).
class ImpactStoryScreen extends StatefulWidget {
  const ImpactStoryScreen({super.key, required this.storyId});

  final String storyId;

  @override
  State<ImpactStoryScreen> createState() => _ImpactStoryScreenState();
}

class _ImpactStoryScreenState extends State<ImpactStoryScreen> {
  final _bloc = getIt<ImpactStoryBloc>();
  String? _lang;

  void _load() =>
      _bloc.add(ImpactStoryRequested(id: widget.storyId, lang: _lang ?? 'en'));

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
    return BlocBuilder<ImpactStoryBloc, ImpactStoryState>(
      bloc: _bloc,
      builder: (context, state) {
        final Widget body = switch (state) {
          ImpactStoryLoaded(:final story) => _StoryBody(story: story),
          ImpactStoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ImpactStoryNotFound() => CausesMessage(
            icon: Icons.search_off_rounded,
            message: l10n.impactStoryNotFound,
          ),
          ImpactStoryFailed() => CausesMessage(
            icon: Icons.cloud_off_outlined,
            message: l10n.impactStoryLoadError,
            onRetry: _load,
          ),
        };
        if (state is ImpactStoryLoaded) return Scaffold(body: body);
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ZakatPageHeader(title: l10n.impactBarakaStories),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

class _StoryBody extends StatelessWidget {
  const _StoryBody({required this.story});

  final ImpactStory story;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.contentLocale;
    final scheme = Theme.of(context).colorScheme;
    final imageUrl = story.imageUrl;
    final publishedAt = story.publishedAt;
    final text = (story.body ?? story.summary ?? '').trim();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CauseCategoryBackdrop(category: story.category, iconSize: 30),
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
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
                          backgroundColor: Colors.black.withValues(alpha: 0.25),
                        ),
                        color: Colors.white,
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
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          sliver: SliverList.list(
            children: [
              Text(
                story.title,
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
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TagPill(label: story.category.label(l10n)),
                  if (story.region != null)
                    _MetaText(icon: Icons.place_outlined, label: story.region!),
                  if (publishedAt != null)
                    _MetaText(
                      icon: Icons.event_outlined,
                      label: l10n.impactPublishedOn(
                        formatCauseDate(locale, publishedAt),
                      ),
                    ),
                ],
              ),
              if (text.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  text,
                  style: AppTypography.body(
                    fontSize: 15,
                    color: scheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.label});

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
