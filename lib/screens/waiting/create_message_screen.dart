import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../models/scheduled_letter.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/forms/app_text_field.dart';
import '../../widgets/forms/date_field.dart';
import '../../widgets/forms/form_screen_scaffold.dart';
import '../../widgets/forms/image_attachment_field.dart';
import '../../widgets/forms/people_picker_field.dart';
import '../add/friends_loader.dart';
import '../add/save_mixin.dart';

/// Create a Waiting Message: recipient, title, message, optional image,
/// and the date + time it opens. Returns `true` when scheduled.
class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({super.key});

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen>
    with FriendsLoader, SaveFlow {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();

  AppUser? _me;
  AppUser? _recipient;
  String? _imagePath;
  bool _pickingImage = false;
  bool _recipientMissing = false;
  bool _timeInPast = false;

  /// Date part (time ignored) and time part (date ignored) of the opening.
  late DateTime _day;
  late TimeOfDay _time;

  DateTime get _now => AppScope.of(context).clock.now();

  DateTime get _openAt =>
      DateTime(_day.year, _day.month, _day.day, _time.hour, _time.minute);

  @override
  void initState() {
    super.initState();
    final start = _now.add(const Duration(days: 1));
    _day = DateTime(start.year, start.month, start.day);
    _time = const TimeOfDay(hour: 9, minute: 0);
    AppScope.of(context).createService.currentUser().then((me) {
      if (mounted) setState(() => _me = me);
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _pickingImage = true);
    try {
      final path = await AppScope.of(context).mediaPicker.pickImage();
      if (mounted && path != null) setState(() => _imagePath = path);
    } catch (e) {
      debugPrint('Image pick failed: $e');
      if (mounted) showAppSnackBar(context, context.l10n.imagePickFailed);
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }

  void _save() {
    final inPast = !_openAt.isAfter(_now);
    setState(() {
      _recipientMissing = _recipient == null;
      _timeInPast = inPast;
    });
    final valid = _formKey.currentState!.validate();
    if (!valid || _recipient == null || inPast) return;

    runSave(
      () => AppScope.of(context).createService.scheduleLetter(
        kind: LetterKind.message,
        recipient: _recipient!,
        title: _title.text,
        body: _body.text,
        openAt: _openAt,
        imageUrls: [?_imagePath],
      ),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = _now;
    final today = DateTime(now.year, now.month, now.day);

    return FormScreenScaffold(
      title: l.createMessage,
      subtitle: l.createMessageSubtitle,
      formKey: _formKey,
      busy: busy,
      primaryLabel: l.scheduleMessage,
      primaryIcon: Icons.schedule_send_outlined,
      onPrimary: _save,
      fields: [
        PeoplePickerField(
          label: l.fieldRecipient,
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
          label: l.fieldMessageTitle,
          controller: _title,
          hint: l.messageTitleHint,
          maxLength: 80,
          validator: AppTextField.required(l.messageTitleRequired),
        ),
        AppTextField(
          label: l.fieldMessage,
          controller: _body,
          hint: l.messageBodyHint,
          minLines: 5,
          maxLines: 14,
          maxLength: 4000,
          validator: AppTextField.required(l.messageRequired),
        ),
        ImageAttachmentField(
          label: l.fieldImage,
          source: _imagePath,
          busy: _pickingImage,
          onPick: _pickImage,
          onRemove: () => setState(() => _imagePath = null),
        ),
        DateField(
          label: l.fieldOpenDay,
          value: _day,
          minimumDate: today,
          helper: formatDaysUntil(l, _day, now: now),
          onChanged: (d) => setState(() {
            _day = DateTime(d.year, d.month, d.day);
            _timeInPast = false;
          }),
        ),
        DateField(
          label: l.fieldOpenTime,
          mode: DateFieldMode.time,
          value: _openAt,
          errorText: _timeInPast ? l.openTimeInPast : null,
          onChanged: (t) => setState(() {
            _time = TimeOfDay(hour: t.hour, minute: t.minute);
            _timeInPast = false;
          }),
        ),
      ],
    );
  }
}
