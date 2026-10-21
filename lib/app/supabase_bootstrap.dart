import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/supabase_config.dart';

/// Connects to Supabase. Call once, before `runApp`.
///
/// Until a project URL and publishable key are configured, this is skipped
/// and the app keeps running on its local data.
Future<void> initializeSupabase() async {
  if (!SupabaseConfig.isConfigured) {
    debugPrint(
      'Supabase: not configured (set SupabaseConfig.url and '
      'publishableKey). Running with local data only.',
    );
    return;
  }
  SupabaseConfig.ensureClientSafeKey(SupabaseConfig.publishableKey);
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  debugPrint('Supabase: initialized for ${SupabaseConfig.url}');
}
