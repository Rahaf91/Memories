import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../common/empty_state_card.dart';
import '../common/user_avatar.dart';

/// What the user chose in the "Start a chat" sheet.
sealed class StartChatChoice {
  const StartChatChoice();
}

class ChatWith extends StartChatChoice {
  const ChatWith(this.friend);
  final AppUser friend;
}

class AddFriendInstead extends StartChatChoice {
  const AddFriendInstead();
}

/// Lists friends to start a chat with, or offers to add one.
Future<StartChatChoice?> showStartChatSheet(
  BuildContext context, {
  required List<AppUser> friends,
}) {
  return showModalBottomSheet<StartChatChoice>(
    context: context,
    backgroundColor: AppColors.background,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final l = context.l10n;
      return SafeArea(
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
                l.startChatTitle,
                style: AppTypography.of(context).cardTitle,
              ),
            ),
            if (friends.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                ),
                child: EmptyStateCard(
                  icon: Icons.person_add_alt_outlined,
                  title: l.friendsEmptyTitle,
                  message: l.friendsEmptyBody,
                  actionLabel: l.addFriend,
                  onAction: () =>
                      Navigator.of(context).pop(const AddFriendInstead()),
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  children: [
                    for (final f in friends)
                      ListTile(
                        onTap: () => Navigator.of(context).pop(ChatWith(f)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        leading: UserAvatar(user: f, size: 40),
                        title: Text(f.displayName),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ListTile(
                      onTap: () =>
                          Navigator.of(context).pop(const AddFriendInstead()),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add_alt_outlined,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        l.addFriend,
                        style: const TextStyle(
                          color: AppColors.accentDeep,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    },
  );
}
