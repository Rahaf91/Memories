import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';

/// Voice-note row (play button, waveform, duration). Playback isn't wired
/// yet; this is the layout real audio will plug into.
class LetterAudioSection extends StatelessWidget {
  const LetterAudioSection({super.key, this.duration, this.onPlay});

  final Duration? duration;
  final VoidCallback? onPlay;

  String _format(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: onPlay,
            tooltip: context.l10n.voiceNote,
            style: IconButton.styleFrom(backgroundColor: AppColors.accent),
            icon: const Icon(Icons.play_arrow_rounded),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(child: SizedBox(height: 32, child: _Waveform())),
          if (duration != null) ...[
            const SizedBox(width: AppSpacing.md),
            Text(_format(duration!), style: textTheme.labelMedium),
          ],
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _WaveformPainter());
}

class _WaveformPainter extends CustomPainter {
  // Fixed, gentle shape until real amplitude data exists.
  static const _levels = [
    .3,
    .5,
    .8,
    .6,
    .4,
    .7,
    1,
    .6,
    .35,
    .55,
    .8,
    .5,
    .3,
    .6,
    .9,
    .7,
    .45,
    .3,
    .5,
    .75,
    .55,
    .35,
    .6,
    .8,
    .5,
    .3,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.55)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final step = size.width / _levels.length;
    for (var i = 0; i < _levels.length; i++) {
      final x = step * (i + 0.5);
      final h = size.height * _levels[i];
      canvas.drawLine(
        Offset(x, (size.height - h) / 2),
        Offset(x, (size.height + h) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => false;
}
