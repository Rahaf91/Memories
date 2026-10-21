import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../common/empty_state_card.dart';
import '../common/user_avatar.dart';
import 'field_label.dart';

/// Labeled field for choosing people from a list (multi or single select).
class PeoplePickerField extends StatelessWidget {
  const PeoplePickerField({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.single = false,
    this.optional = false,
    this.addLabel,
    this.errorText,
    this.onAddFriend,
    this.nameOf,
  });

  final String label;

  /// Available people; null while loading.
  final List<AppUser>? options;
  final List<AppUser> selected;
  final ValueChanged<List<AppUser>> onChanged;

  /// Allow only one person (e.g. a letter's recipient).
  final bool single;
  final bool optional;

  /// Label of the add button (defaults to "Add people").
  final String? addLabel;
  final String? errorText;

  /// Offered when there are no friends to pick from. Should return the
  /// newly added friend (or null), which is then selected.
  final Future<AppUser?> Function()? onAddFriend;

  /// Display name override (e.g. "Future you" for the user themself).
  /// Return null to use the default name.
  final String? Function(AppUser)? nameOf;

  Future<void> _openPicker(BuildContext context) async {
    final people = options;
    if (people == null) return;
    final result = await showModalBottomSheet<_PickResult>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _PeopleSheet(
        nameOf: nameOf,
        title: label,
        people: people,
        initial: selected,
        single: single,
        canAddFriend: onAddFriend != null,
      ),
    );
    switch (result) {
      case _Picked(:final people):
        onChanged(people);
      case _AddFriend():
        final friend = await onAddFriend?.call();
        if (friend != null) {
          onChanged(single ? [friend] : [...selected, friend]);
        }
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final loading = options == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, optional: optional),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: fieldBoxDecoration(hasError: errorText != null),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final person in selected)
                _PersonChip(
                  user: person,
                  label: nameOf?.call(person) ?? person.firstName,
                  onRemove: () => onChanged(
                    selected.where((p) => p.id != person.id).toList(),
                  ),
                ),
              if (!single || selected.isEmpty)
                ActionChip(
                  onPressed: loading ? null : () => _openPicker(context),
                  avatar: loading
                      ? const SizedBox.square(
                          dimension: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        )
                      : const Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: AppColors.accent,
                        ),
                  label: Text(addLabel ?? l.addPeople),
                  labelStyle: const TextStyle(
                    color: AppColors.accentDeep,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: AppColors.accentSoft,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                )
              else
                TextButton(
                  onPressed: () => _openPicker(context),
                  child: Text(l.change),
                ),
            ],
          ),
        ),
        FieldError(errorText),
      ],
    );
  }
}

sealed class _PickResult {
  const _PickResult();
}

class _Picked extends _PickResult {
  const _Picked(this.people);
  final List<AppUser> people;
}

class _AddFriend extends _PickResult {
  const _AddFriend();
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({
    required this.user,
    required this.label,
    required this.onRemove,
  });

  final AppUser user;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(user: user, size: 26),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: AppColors.textPrimary),
          ),
          Semantics(
            button: true,
            label: context.l10n.removePerson(label),
            child: InkResponse(
              onTap: onRemove,
              radius: 16,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeopleSheet extends StatefulWidget {
  const _PeopleSheet({
    required this.title,
    required this.people,
    required this.initial,
    required this.single,
    required this.canAddFriend,
    this.nameOf,
  });

  final String? Function(AppUser)? nameOf;
  final String title;
  final List<AppUser> people;
  final List<AppUser> initial;
  final bool single;
  final bool canAddFriend;

  @override
  State<_PeopleSheet> createState() => _PeopleSheetState();
}

class _PeopleSheetState extends State<_PeopleSheet> {
  late final Set<String> _ids = {for (final p in widget.initial) p.id};

  void _toggle(AppUser person) {
    if (widget.single) {
      Navigator.of(context).pop(_Picked([person]));
      return;
    }
    setState(() {
      if (!_ids.remove(person.id)) _ids.add(person.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: textTheme.titleLarge),
                ),
                if (!widget.single && widget.people.isNotEmpty)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      _Picked([
                        for (final p in widget.people)
                          if (_ids.contains(p.id)) p,
                      ]),
                    ),
                    child: Text(l.done),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (widget.people.isEmpty)
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
                message: l.noFriendsToPick,
                actionLabel: widget.canAddFriend ? l.addFriend : null,
                onAction: widget.canAddFriend
                    ? () => Navigator.of(context).pop(const _AddFriend())
                    : null,
              ),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                children: [
                  for (final person in widget.people)
                    ListTile(
                      onTap: () => _toggle(person),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      leading: UserAvatar(user: person, size: 40),
                      title: Text(
                        widget.nameOf?.call(person) ?? person.displayName,
                      ),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: _ids.contains(person.id)
                            ? const Icon(
                                Icons.check_circle_rounded,
                                key: ValueKey(true),
                                color: AppColors.accent,
                              )
                            : const Icon(
                                Icons.radio_button_unchecked_rounded,
                                key: ValueKey(false),
                                color: AppColors.stone,
                              ),
                      ),
                    ),
                  if (widget.canAddFriend)
                    ListTile(
                      onTap: () =>
                          Navigator.of(context).pop(const _AddFriend()),
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
  }
}
