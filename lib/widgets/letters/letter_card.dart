import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';
import '../common/overline_text.dart';
import '../common/pressable.dart';
import '../common/user_avatar.dart';
import 'letter_labels.dart';
import 'letter_status_pill.dart';
import 'sealed_preview.dart';

/// Hero tag linking a letter card to its full-screen reveal.
String letterHeroTag(String letterId) => 'letter-$letterId';

/// Corner radius of the card (the reveal animates it to square).
const double letterCardRadius = AppRadius.xl;

/// Home card for an "Open When" letter addressed to the user.
///
/// Its state comes from the clock and the saved letter: it schedules a
/// timer for the exact unlock time and turns "ready" on its own.
class LetterCard extends StatefulWidget {
  const LetterCard({
    super.key,
    required this.letter,
    required this.viewerId,
    required this.onTap,
  });

  final ScheduledLetter letter;

  /// The signed-in user (decides "To …" vs "From …").
  final String viewerId;
  final VoidCallback onTap;

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard>
    with SingleTickerProviderStateMixin {
  Timer? _unlockTimer;

  /// Whether the ready glow already played for this card.
  bool _glowed = false;

  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(LetterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  LetterState get _state =>
      widget.letter.stateAt(AppScope.of(context).clock.now());

  /// Arms the unlock timer and the "ready" glow for the current state.
  void _sync() {
    _unlockTimer?.cancel();
    final now = AppScope.of(context).clock.now();
    final state = widget.letter.stateAt(now);
    if (state == LetterState.locked) {
      _unlockTimer = Timer(widget.letter.openAt.difference(now), () {
        if (mounted) setState(_sync);
      });
    }
    final animate =
        state == LetterState.ready &&
        !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    if (animate) {
      // A few slow breaths when it becomes ready, then rest on a steady
      // highlight (no endless animation draining the battery).
      if (!_glow.isAnimating && !_glowed) {
        _glowed = true;
        _glow.repeat(reverse: true, count: 4);
      }
    } else {
      _glow
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _unlockTimer?.cancel();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final letter = widget.letter;
    final state = _state;
    final textTheme = Theme.of(context).textTheme;

    final from = letter.counterpart(l, widget.viewerId);
    // Show the other person's avatar (the recipient for messages you sent).
    final person = letter.author.id == widget.viewerId && !letter.isToSelf
        ? letter.recipient
        : letter.author;
    final (String trailing, String? sub) = switch (state) {
      LetterState.locked => (
        l.opensOn(formatDateTime(l, letter.openAt)),
        formatDaysUntil(l, letter.openAt),
      ),
      LetterState.ready || LetterState.opening => (l.readyToOpen, null),
      LetterState.opened => (
        l.openedOn(formatShortDate(l, letter.openedAt!)),
        null,
      ),
    };

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: OverlineText(letter.overline(l))),
            const SizedBox(width: AppSpacing.sm),
            LetterStatusPill(state: state),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          letter.headline(l),
          style: AppTypography.of(context).featuredQuote,
        ),
        const SizedBox(height: AppSpacing.md),
        if (state == LetterState.opened)
          Text(
            letter.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          )
        else
          SealedPreview(
            icon: state == LetterState.locked
                ? Icons.lock_outline_rounded
                : Icons.touch_app_outlined,
            label: state == LetterState.locked ? l.sealedMessage : l.tapToOpen,
          ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, box) {
            final rowWidth = box.maxWidth;
            return Row(
              children: [
                UserAvatar(
                  user: person,
                  size: 28,
                  borderColor: AppColors.surface,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    from,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Up to 60% of the row; wraps only on narrow screens or large
                // text sizes.
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: rowWidth * 0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trailing,
                        textAlign: TextAlign.end,
                        style: textTheme.labelLarge?.copyWith(
                          color: state == LetterState.ready
                              ? AppColors.accentDeep
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (sub != null)
                        Text(
                          sub,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );

    return Semantics(
      button: true,
      label: [letter.headline(l), from, trailing].join(', '),
      excludeSemantics: true,
      child: Pressable(
        onTap: widget.onTap,
        pressedScale: 0.985,
        child: Hero(
          tag: letterHeroTag(letter.id),
          child: AnimatedBuilder(
            animation: _glow,
            builder: (context, child) => Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: AppGradients.featured,
                borderRadius: BorderRadius.circular(letterCardRadius),
                border: Border.all(
                  color: AppColors.accent.withValues(
                    alpha: state == LetterState.ready
                        ? 0.25 + 0.2 * _glow.value
                        : 0.12,
                  ),
                ),
                boxShadow: [
                  if (state == LetterState.ready)
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: 0.10 + 0.12 * _glow.value,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: child,
            ),
            // Material keeps text styled correctly during the hero flight.
            child: Material(type: MaterialType.transparency, child: content),
          ),
        ),
      ),
    );
  }
}
