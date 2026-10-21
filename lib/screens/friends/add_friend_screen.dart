import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../l10n/l10n.dart';
import '../../widgets/forms/app_text_field.dart';
import '../../widgets/forms/form_screen_scaffold.dart';
import '../add/save_mixin.dart';

/// Adds a friend locally. Returns the new [AppUser] on success.
///
/// With a backend this becomes a friend request / invite sent to the
/// email or phone number.
class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> with SaveFlow {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    runSave(
      () =>
          AppScope.of(context).friendsService
              .addFriend(_name.text, contact: _contact.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FormScreenScaffold(
      title: l.addFriend,
      subtitle: l.addFriendSubtitle,
      formKey: _formKey,
      busy: busy,
      primaryLabel: l.addFriend,
      primaryIcon: Icons.person_add_alt_outlined,
      onPrimary: _save,
      fields: [
        AppTextField(
          label: l.fieldName,
          controller: _name,
          hint: l.nameHint,
          maxLength: 60,
          validator: AppTextField.required(l.nameRequired),
        ),
        AppTextField(
          label: l.fieldContact,
          controller: _contact,
          hint: l.contactHint,
          optional: true,
          maxLength: 120,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
