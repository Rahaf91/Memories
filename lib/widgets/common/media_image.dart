import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Image provider for a media reference: a remote URL (uploaded media) or a
/// local file path (a photo just picked on the device). Null when [source]
/// is empty.
ImageProvider? mediaImageProvider(String? source) {
  if (source == null || source.isEmpty) return null;
  if (source.startsWith('http://') || source.startsWith('https://')) {
    return NetworkImage(source);
  }
  return FileImage(File(source));
}

/// Shows user media, or a neutral placeholder frame when there is none.
///
/// The app ships with no images: every media area renders this placeholder
/// until the user adds their own photos. Once uploads exist, passing the
/// stored URL (or a local file path before upload) is all that's needed.
class MediaImage extends StatelessWidget {
  const MediaImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.width,
    this.height,
    this.showPlaceholderIcon = true,
  });

  /// URL or local file path; null for "no image yet".
  final String? source;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  /// Show a small image icon in the empty frame (hidden on tiny frames).
  final bool showPlaceholderIcon;

  @override
  Widget build(BuildContext context) {
    final provider = mediaImageProvider(source);
    final placeholder = MediaPlaceholder(showIcon: showPlaceholderIcon);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: provider == null
            ? placeholder
            : Image(
                image: provider,
                fit: fit,
                width: width,
                height: height,
                frameBuilder: (context, child, frame, wasSync) {
                  if (wasSync) return child;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      placeholder,
                      AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      ),
                    ],
                  );
                },
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

/// Empty media frame: a soft beige block with an optional image icon.
class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({super.key, this.showIcon = true});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: showIcon
          ? LayoutBuilder(
              builder: (context, constraints) {
                final side = constraints.biggest.shortestSide;
                if (!side.isFinite || side < 48) return const SizedBox.expand();
                return Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: (side * 0.16).clamp(18, 32),
                    color: AppColors.stone,
                  ),
                );
              },
            )
          : const SizedBox.expand(),
    );
  }
}
