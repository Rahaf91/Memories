import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../l10n/l10n.dart';
import '../../../models/app_user.dart';
import '../../../services/create_service.dart';
import '../../../widgets/common/coming_soon.dart';
import '../../../widgets/forms/app_text_field.dart';
import '../../../widgets/forms/choice_segments.dart';
import '../../../widgets/forms/date_field.dart';
import '../../../widgets/forms/form_screen_scaffold.dart';
import '../../../widgets/forms/image_placeholder_area.dart';
import '../../../widgets/forms/people_picker_field.dart';
import '../friends_loader.dart';
import '../save_mixin.dart';

/// First step of saving a memory. Returns `true` when saved.
class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen>
    with FriendsLoader, SaveFlow {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _caption = TextEditingController();
  DateTime _date = DateTime.now();
  List<AppUser> _people = const [];
  MemoryPrivacy _privacy = MemoryPrivacy.private;
  bool _peopleMissing = false;

  /// Photo picked on the device (uploaded when saving).
  String? _imagePath;
  bool _pickingImage = false;

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

  @override
  void dispose() {
    _title.dispose();
    _caption.dispose();
    super.dispose();
  }

  void _save() {
    final needsPeople = _privacy == MemoryPrivacy.selected && _people.isEmpty;
    setState(() => _peopleMissing = needsPeople);
    final valid = _formKey.currentState!.validate();
    if (!valid || needsPeople) return;

    runSave(
      () => AppScope.of(context).createService.createMemory(
        title: _title.text,
        caption: _caption.text,
        date: _date,
        people: _people,
        privacy: _privacy,
        imagePath: _imagePath,
      ),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FormScreenScaffold(
      title: l.addMemory,
      subtitle: l.addMemorySubtitle,
      formKey: _formKey,
      busy: busy,
      primaryLabel: l.saveMemory,
      onPrimary: _save,
      fields: [
        ImagePlaceholderArea(
          source: _imagePath,
          busy: _pickingImage,
          onTap: _pickImage,
          onRemove: () => setState(() => _imagePath = null),
        ),
        AppTextField(
          label: l.fieldTitle,
          controller: _title,
          hint: l.titleHint,
          maxLength: 80,
          validator: AppTextField.required(l.titleRequired),
        ),
        DateField(
          label: l.fieldDate,
          value: _date,
          maximumDate: DateTime.now(),
          onChanged: (d) => setState(() => _date = d),
        ),
        PeoplePickerField(
          label: l.fieldPeopleInvolved,
          options: friends,
          selected: _people,
          optional: _privacy != MemoryPrivacy.selected,
          errorText: _peopleMissing ? l.choosePeopleError : null,
          onAddFriend: addFriendFromPicker,
          onChanged: (p) => setState(() {
            _people = p;
            _peopleMissing = false;
          }),
        ),
        AppTextField(
          label: l.fieldCaption,
          controller: _caption,
          hint: l.captionHint,
          optional: true,
          minLines: 3,
          maxLines: 6,
          maxLength: 500,
        ),
        ChoiceSegments<MemoryPrivacy>(
          label: l.fieldWhoCanSee,
          options: MemoryPrivacy.values,
          selected: _privacy,
          labelOf: (p) => switch (p) {
            MemoryPrivacy.private => l.privacyPrivate,
            MemoryPrivacy.friends => l.privacyFriends,
            MemoryPrivacy.selected => l.privacySelected,
          },
          descriptionOf: (p) => switch (p) {
            MemoryPrivacy.private => l.privacyPrivateDesc,
            MemoryPrivacy.friends => l.privacyFriendsDesc,
            MemoryPrivacy.selected => l.privacySelectedDesc,
          },
          iconOf: (p) => switch (p) {
            MemoryPrivacy.private => Icons.lock_outline_rounded,
            MemoryPrivacy.friends => Icons.groups_outlined,
            MemoryPrivacy.selected => Icons.people_outline_rounded,
          },
          onChanged: (p) => setState(() {
            _privacy = p;
            _peopleMissing = false;
          }),
        ),
      ],
    );
  }
}
