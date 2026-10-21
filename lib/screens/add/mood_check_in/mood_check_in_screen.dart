import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../l10n/l10n.dart';
import '../../../models/mood.dart';
import '../../../widgets/forms/app_text_field.dart';
import '../../../widgets/forms/form_screen_scaffold.dart';
import '../../../widgets/home/mood_selector.dart';
import '../save_mixin.dart';

/// Five faces and an optional note. Returns `true` when saved.
class MoodCheckInScreen extends StatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  State<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> with SaveFlow {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();
  Mood? _mood;

  @override
  void initState() {
    super.initState();
    // Start from today's check-in, if there is one.
    AppScope.of(context).createService.getTodayMood().then((entry) {
      if (!mounted || entry == null || _mood != null) return;
      setState(() {
        _mood = entry.mood;
        _note.text = entry.note ?? '';
      });
    });
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _save() {
    final mood = _mood;
    if (mood == null) return;
    runSave(
      () => AppScope.of(context).createService.checkIn(mood, note: _note.text),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FormScreenScaffold(
      title: l.moodCheckInTitle,
      subtitle: l.moodCheckInSubtitle,
      formKey: _formKey,
      busy: busy,
      primaryLabel: l.saveCheckIn,
      onPrimary: _mood == null ? null : _save,
      fields: [
        MoodSelector(
          selected: _mood,
          size: 56,
          onSelected: (m) => setState(() => _mood = m),
        ),
        AppTextField(
          label: l.moodNoteLabel,
          controller: _note,
          hint: l.moodNoteHint,
          optional: true,
          minLines: 2,
          maxLines: 4,
          maxLength: 300,
        ),
      ],
    );
  }
}
