import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../common/glass_icon_button.dart';
import '../common/media_image.dart';
import '../common/pressable.dart';

/// Photo area for a form: an empty frame that opens the photo picker, or
/// the chosen photo filling the same frame (tap to change, × to remove).
class ImagePlaceholderArea extends StatelessWidget {
  const ImagePlaceholderArea({
    super.key,
    this.onTap,
    this.source,
    this.onRemove,
    this.busy = false,
  });

  /// Opens the picker (also used to change the chosen photo).
  final VoidCallback? onTap;

  /// Chosen photo (local path or URL); null shows the empty frame.
  final String? source;
  final VoidCallback? onRemove;

  /// Shows a spinner while the picker is open.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final photo = source;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Semantics(
      button: true,
      label: l.addPhotos,
      child: Pressable(
        onTap: busy ? null : onTap,
        pressedScale: 0.985,
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: radius,
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (photo != null)
                  MediaImage(source: photo, borderRadius: radius)
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l.addPhotos,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.photoUploadSoon,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                if (photo != null && onRemove != null)
                  PositionedDirectional(
                    top: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: GlassIconButton(
                      icon: Icons.close_rounded,
                      tooltip: l.removeImage,
                      onPressed: onRemove!,
                    ),
                  ),
                if (busy)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.6),
                      borderRadius: radius,
                    ),
                    child: const Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
