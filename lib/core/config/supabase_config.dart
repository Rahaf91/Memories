import 'dart:convert';

/// Supabase connection settings for the app.
///
/// Only the project URL and the *publishable* key belong here. Both are
/// designed to ship inside client apps; data is protected by Row Level
/// Security on the database, not by hiding this key. Never put a secret or
/// service-role key in the app.
///
/// Values can also be supplied at build time, e.g.
/// `flutter run --dart-define=SUPABASE_URL=… --dart-define=SUPABASE_PUBLISHABLE_KEY=…`
abstract final class SupabaseConfig {
  static const _rawUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ybsdqubzsnbtwrmtnimk.supabase.co',
  );

  /// Project base URL. A pasted API path (e.g. `/rest/v1/`) is stripped:
  /// the client adds those paths itself.
  static String get url => normalizeUrl(_rawUrl);

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_6-_YanF6avuyUTT6uxWa5w_b_4avHDo',
  );

  /// `https://x.supabase.co/rest/v1/` → `https://x.supabase.co`
  static String normalizeUrl(String raw) {
    var u = raw.trim();
    for (final suffix in const ['/rest/v1', '/auth/v1', '/storage/v1']) {
      final i = u.indexOf(suffix);
      if (i >= 0) u = u.substring(0, i);
    }
    while (u.endsWith('/')) {
      u = u.substring(0, u.length - 1);
    }
    return u;
  }

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  /// Throws if [key] is a secret / service-role key, which must never be
  /// embedded in a client app.
  static void ensureClientSafeKey(String key) {
    if (key.startsWith('sb_secret_')) {
      throw StateError(
        'A Supabase secret key was configured. Use the publishable key '
        '(sb_publishable_…) in the app, never a secret key.',
      );
    }
    // Legacy JWT keys: reject the service_role one.
    final parts = key.split('.');
    if (parts.length == 3) {
      try {
        final payload = utf8.decode(
          base64Url.decode(base64Url.normalize(parts[1])),
        );
        if ((jsonDecode(payload) as Map)['role'] == 'service_role') {
          throw StateError(
            'A Supabase service_role key was configured. Use the '
            'publishable key in the app, never the service_role key.',
          );
        }
      } on FormatException {
        // Not a JWT; nothing to check.
      }
    }
  }
}
