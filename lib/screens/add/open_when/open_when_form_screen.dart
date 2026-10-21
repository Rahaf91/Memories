import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../core/utils/date_format.dart';
import '../../../l10n/l10n.dart';
import '../../../models/app_user.dart';
import '../../../widgets/forms/app_text_field.dart';
import '../../../widgets/forms/date_field.dart';
import '../../../widgets/forms/form_screen_scaffold.dart';
import '../../../widgets/forms/people_picker_field.dart';
import '../friends_loader.dart';
import '../save_mixin.dart';

/// First step of writing an "Open When" letter. Returns `true` when
/// scheduled.
class OpenWhenFormScreen extends StatefulWidget {
  const OpenWhenFormScreen({super.key});

  @override
  State<OpenWhenFormScreen> createState() => _OpenWhenFormScreenState();
}

class _OpenWhenFormScreenState extends State<OpenWhenFormScreen>
    with FriendsLoader, SaveFlow {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _note = TextEditingController();
  late DateTime _openAt = _morningOf(_now.add(const Duration(days: 7)));
  AppUser? _recipient;

  /// The user, offered as "Future you".
  AppUser? _me;

  DateTime get _now => AppScope.of(context).clock.now();
  bool _recipientMissing = false;

  static DateTime _morningOf(DateTime d) => DateTime(d.year, d.month, d.day, 9);

  /// Earliest unlock: one minute from now.
  DateTime get _earliest => _now.add(const Duration(minutes: 1));

  @override
  void initState() {
    super.initState();
    AppScope.of(context).createService.currentUser().then((me) {
      if (mounted) setState(() => _me = me);
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _recipientMissing = _recipient == null);
    final valid = _formKey.currentState!.validate();
    if (!valid || _recipient == null) return;

    runSave(
      () => AppScope.of(context).createService.scheduleLetter(
        recipient: _recipient!,
        title: _title.text,
        body: _body.text,
        openAt: _openAt,
        note: _note.text,
      ),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FormScreenScaffold(
      title: l.openWhenTitle,
      subtitle: l.openWhenSubtitle,
      formKey: _formKey,
      busy: busy,
      primaryLabel: l.schedule,
      primaryIcon: Icons.schedule_send_outlined,
      onPrimary: _save,
      fields: [
        PeoplePickerField(
          label: l.fieldFor,
          options: friends == null ? null : [?_me, ...friends!],
          nameOf: (u) => u.id == _me?.id ? l.futureYou : null,
          selected: [?_recipient],
          single: true,
          addLabel: l.chooseRecipient,
          errorText: _recipientMissing ? l.recipientRequired : null,
          onAddFriend: addFriendFromPicker,
          onChanged: (p) => setState(() {
            _recipient = p.isEmpty ? null : p.first;
            _recipientMissing = false;
          }),
        ),
        AppTextField(
          label: l.fieldOpenWhen,
          controller: _title,
          hint: l.openWhenHint,
          maxLength: 90,
          validator: AppTextField.required(l.openWhenRequired),
        ),
        AppTextField(
          label: l.fieldMessage,
          controller: _body,
          hint: l.messageBodyHint,
          minLines: 6,
          maxLines: 14,
          maxLength: 4000,
          validator: AppTextField.required(l.messageRequired),
        ),
        DateField(
          label: l.fieldOpenDate,
          value: _openAt,
          minimumDate: _earliest,
          helper: formatDaysUntil(l, _openAt, now: _now),
          includeTime: true,
          onChanged: (d) => setState(() => _openAt = d),
        ),
        AppTextField(
          label: l.fieldNoteToSelf,
          controller: _note,
          hint: l.noteToSelfHint,
          optional: true,
          minLines: 2,
          maxLines: 4,
          maxLength: 300,
        ),
      ],
    );
  }
}
