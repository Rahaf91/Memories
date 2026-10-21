import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/repositories/media_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common/coming_soon.dart';

/// Shared "busy → save → go back" handling for create forms.
mixin SaveFlow<T extends StatefulWidget> on State<T> {
  bool busy = false;

  /// Runs [action]; on success returns to the previous screen with [result]
  /// (defaults to `true`).
  Future<void> runSave(
    Future<Object?> Function() action, {
    Object? result,
  }) async {
    if (busy) return;
    FocusScope.of(context).unfocus();
    setState(() => busy = true);
    try {
      final value = await action();
      if (mounted) Navigator.of(context).pop(result ?? value ?? true);
    } catch (e) {
      debugPrint('Save failed: $e');
      if (!mounted) return;
      setState(() => busy = false);
      showAppSnackBar(
        context,
        e is MediaUploadException
            ? context.l10n.photoUploadFailed
            : _isNetworkError(e)
            ? context.l10n.authErrorNetwork
            : context.l10n.saveFailed,
      );
    }
  }

  /// No connection (offline, DNS, timeouts) vs. any other failure.
  static bool _isNetworkError(Object e) {
    if (e is SocketException || e is TimeoutException) return true;
    final text = '$e';
    return text.contains('SocketException') ||
        text.contains('Failed host lookup') ||
        text.contains('Connection closed') ||
        text.contains('ClientException');
  }
}
