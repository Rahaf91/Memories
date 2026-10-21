import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';

/// Things that can be shared into a chat (placeholders for now).
enum ChatAttachment {
  memory(Icons.add_photo_alternate_outlined),
  openWhen(Icons.schedule_send_outlined),
  waitingMessage(Icons.hourglass_empty_rounded);

  const ChatAttachment(this.icon);

  final IconData icon;

  String label(AppLocalizations l) => switch (this) {
    ChatAttachment.memory => l.addMemory,
    ChatAttachment.openWhen => l.sendOpenWhen,
    ChatAttachment.waitingMessage => l.attachWaitingMessage,
  };

  String description(AppLocalizations l) => switch (this) {
    ChatAttachment.memory => l.attachMemoryDesc,
    ChatAttachment.openWhen => l.sendOpenWhenDesc,
    ChatAttachment.waitingMessage => l.attachWaitingMessageDesc,
  };
}

/// Bottom sheet listing [ChatAttachment] options.
Future<ChatAttachment?> showChatAttachmentSheet(BuildContext context) {
  return showModalBottomSheet<ChatAttachment>(
    context: context,
    backgroundColor: AppColors.background,
    showDragHandle: true,
    builder: (context) {
      final l = context.l10n;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                ),
                child: Text(
                  l.shareInChat,
                  style: AppTypography.of(context).cardTitle,
                ),
              ),
              for (final option in ChatAttachment.values)
                ListTile(
                  onTap: () => Navigator.of(context).pop(option),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: 2,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(option.icon, color: AppColors.accent),
                  ),
                  title: Text(
                    option.label(l),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(option.description(l)),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
