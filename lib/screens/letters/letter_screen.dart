import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';
import '../../widgets/common/media_image.dart';
import '../../widgets/common/overline_text.dart';
import '../../widgets/common/user_avatar.dart';
import '../../widgets/letters/letter_audio_section.dart';
import '../../widgets/letters/letter_card.dart';
import '../../widgets/letters/letter_labels.dart';

/// Full "Open When" letter.
///
/// With [reveal] (first opening only) the card expands into this screen,
/// the image appears, then the text un-blurs and fades in. When the reveal
/// completes, the opened state is saved. Otherwise the letter is simply
/// shown.
class LetterScreen extends StatefulWidget {
  const LetterScreen({
    super.key,
    required this.letter,
    required this.viewerId,
    this.reveal = false,
  });

  final ScheduledLetter letter;

  /// The signed-in user (private notes show only to the author).
  final String viewerId;
  final bool reveal;

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  late ScheduledLetter _letter = widget.letter;
  late LetterState _state = widget.reveal
      ? LetterState.opening
      : LetterState.opened;
  Animation<double>? _route;
  bool _started = false;

  // Reveal phases (fractions of the reveal controller).
  late final _image = CurvedAnimation(
    parent: _reveal,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
  );
  late final _text = CurvedAnimation(
    parent: _reveal,
    curve: const Interval(0.25, 0.9, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.reveal) _reveal.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.reveal || _started) return;
    _started = true;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _route = ModalRoute.of(context)?.animation;
    if (reduceMotion || _route == null || _route!.isCompleted) {
      _startReveal(instant: reduceMotion);
    } else {
      // Begin once the card has finished expanding.
      _route!.addStatusListener(_onRouteStatus);
    }
  }

  void _onRouteStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _route?.removeStatusListener(_onRouteStatus);
      _startReveal();
    }
  }

  Future<void> _startReveal({bool instant = false}) async {
    if (instant) {
      _reveal.value = 1;
    } else {
      await _reveal.forward().orCancel.catchError((_) {});
    }
    if (!mounted || _reveal.value < 1) return;
    // The reveal finished: this is the first successful opening.
    try {
      final saved = await AppScope.of(context).lettersService
          .markOpened(_letter);
      if (!mounted) return;
      HapticFeedback.lightImpact();
      setState(() {
        _letter = saved;
        _state = LetterState.opened;
      });
    } catch (e) {
      debugPrint('Saving opened state failed: $e');
    }
  }

  @override
  void dispose() {
    _route?.removeStatusListener(_onRouteStatus);
    _image.dispose();
    _text.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background = const DecoratedBox(
      decoration: BoxDecoration(gradient: AppGradients.featured),
      child: SizedBox.expand(),
    );

    return Scaffold(
      backgroundColor: widget.reveal ? Colors.transparent : null,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.reveal
                ? Hero(
                    tag: letterHeroTag(_letter.id),
                    flightShuttleBuilder: _shuttle,
                    child: background,
                  )
                : background,
          ),
          SafeArea(child: _content(context)),
        ],
      ),
    );
  }

  /// During the flight, the card's surface grows and its corners square off.
  Widget _shuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.featured,
          borderRadius: BorderRadius.circular(
            lerpDouble(letterCardRadius, 0, animation.value)!,
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final l = context.l10n;
    final letter = _letter;
    final textTheme = Theme.of(context).textTheme;
    final viewerIsAuthor = letter.author.id == widget.viewerId;
    final from = letter.counterpart(l, widget.viewerId);
    final person = letter.author.id == widget.viewerId && !letter.isToSelf
        ? letter.recipient
        : letter.author;
    final routeFade =
        ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1.0);

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: routeFade,
        curve: const Interval(0.5, 1, curve: Curves.easeOut),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xxl + AppSpacing.lg,
          AppSpacing.screenPadding,
          AppSpacing.xxl,
        ),
        children: [
          OverlineText(letter.overline(l)),
          const SizedBox(height: AppSpacing.md),
          Text(
            letter.headline(l),
            style: AppTypography.of(context).featuredQuote.copyWith(
              fontSize: AppTypography.of(context).isArabic ? 26 : 34,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              UserAvatar(user: person, size: 32),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  from,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.writtenOn(formatShortDate(l, letter.createdAt)),
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          const SizedBox(height: AppSpacing.xl),

          // Media first…
          for (final url in letter.imageUrls) ...[
            FadeTransition(
              opacity: _image,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: MediaImage(
                  source: url,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (letter.audioUrl != null) ...[
            FadeTransition(
              opacity: _image,
              child: LetterAudioSection(duration: letter.audioDuration),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // …then the words: blur lifts and the text fades in.
          AnimatedBuilder(
            animation: _text,
            builder: (context, child) {
              final t = _text.value;
              final sigma = 10 * (1 - t);
              return Opacity(
                opacity: 0.15 + 0.85 * t,
                child: Transform.translate(
                  offset: Offset(0, 8 * (1 - t)),
                  child: sigma < 0.05
                      ? child
                      : ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: sigma,
                            sigmaY: sigma,
                          ),
                          child: child,
                        ),
                ),
              );
            },
            child: Text(
              letter.body,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 17,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _state == LetterState.opened ? 1 : 0,
            child: Row(
              children: [
                const Icon(
                  Icons.drafts_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    letter.openedAt == null
                        ? ''
                        : l.firstOpenedOn(formatDateTime(l, letter.openedAt!)),
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (viewerIsAuthor && letter.note != null) ...[
            const SizedBox(height: AppSpacing.xl),
            OverlineText(l.yourNote),
            const SizedBox(height: AppSpacing.sm),
            Text(letter.note!, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
