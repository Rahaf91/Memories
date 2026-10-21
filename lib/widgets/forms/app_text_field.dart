import 'package:flutter/material.dart';

import 'field_label.dart';

/// Labeled text input used across all forms.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.optional = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.textInputAction,
    this.prefixText,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints,
    this.suffix,
    this.textCapitalization,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool optional;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  /// Fixed text shown before the input, e.g. "Open when…".
  final String? prefixText;

  /// Overrides the default (text / multiline) keyboard, e.g. email.
  final TextInputType? keyboardType;
  final bool obscureText;
  final Iterable<String>? autofillHints;

  /// Trailing widget inside the field (e.g. show-password toggle).
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final ValueChanged<String>? onSubmitted;

  /// Validator that requires non-blank text.
  static FormFieldValidator<String> required(String message) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    final multiline = maxLines > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, optional: optional),
        TextFormField(
          controller: controller,
          validator: validator,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          keyboardType:
              keyboardType ??
              (multiline ? TextInputType.multiline : TextInputType.text),
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          autofillHints: autofillHints,
          onFieldSubmitted: onSubmitted,
          textInputAction:
              textInputAction ??
              (multiline ? TextInputAction.newline : TextInputAction.next),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            counterText: '',
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
