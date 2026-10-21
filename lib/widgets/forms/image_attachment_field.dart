import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../common/media_image.dart';
import '../common/pressable.dart';
import 'field_label.dart';

/// Optional single image: an empty frame to pick one, or a preview with
/// change/remove actions.
class ImageAttachmentField extends StatelessWidget {
  const ImageAttachmentField({
    super.key,
    required this.label,
    required this.source,
    required this.onPick,
    required this.onRemove,
    this.busy = false,
  });

  final String label;

  /// Local file path or URL; null when no image is attached.
  final String? source;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final image = source;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, optional: true),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: image == null
              ? Semantics(
                  key: const ValueKey('empty'),
                  button: true,
                  label: l.addImage,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: busy ? null : onPick,
                    pressedScale: 0.985,
                    child: Container(
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: busy
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    l.addImage,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                )
              : Column(
                  key: ValueKey(image),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: MediaImage(
                        source: image,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: busy ? null : onPick,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                          label: Text(l.change),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: onRemove,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                          ),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: Text(l.removeImage),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
