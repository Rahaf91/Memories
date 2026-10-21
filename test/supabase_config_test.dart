import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:memories/core/config/supabase_config.dart';

void main() {
  String jwt(Map<String, Object> payload) {
    String part(Object o) =>
        base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
    return '${part({'alg': 'HS256'})}.${part(payload)}.signature';
  }

  test('accepts publishable keys', () {
    expect(
      () => SupabaseConfig.ensureClientSafeKey('sb_publishable_abc123'),
      returnsNormally,
    );
    expect(
      () => SupabaseConfig.ensureClientSafeKey(jwt({'role': 'anon'})),
      returnsNormally,
    );
  });

  test('rejects secret and service-role keys', () {
    expect(
      () => SupabaseConfig.ensureClientSafeKey('sb_secret_abc123'),
      throwsStateError,
    );
    expect(
      () => SupabaseConfig.ensureClientSafeKey(jwt({'role': 'service_role'})),
      throwsStateError,
    );
  });

  test('normalizes pasted API URLs to the project base URL', () {
    expect(
      SupabaseConfig.normalizeUrl('https://abc.supabase.co/rest/v1/'),
      'https://abc.supabase.co',
    );
    expect(
      SupabaseConfig.normalizeUrl('https://abc.supabase.co/'),
      'https://abc.supabase.co',
    );
    expect(SupabaseConfig.url, 'https://ybsdqubzsnbtwrmtnimk.supabase.co');
    expect(
      () => SupabaseConfig.ensureClientSafeKey(SupabaseConfig.publishableKey),
      returnsNormally,
    );
  });
}
