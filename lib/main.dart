import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/supabase_bootstrap.dart';
import 'core/config/supabase_config.dart';
import 'data/supabase/supabase_auth_repository.dart';
import 'data/supabase/supabase_letter_repository.dart';
import 'data/supabase/supabase_media_repository.dart';
import 'data/supabase/supabase_memory_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Connect to Supabase before the app starts.
  await initializeSupabase();
  final supabase = SupabaseConfig.isConfigured;
  final dependencies = AppDependencies.local(
    // Real accounts via Supabase Auth (publishable key only).
    authRepository: supabase ? SupabaseAuthRepository() : null,
    // Photos in the private Storage bucket "memory-photos".
    mediaRepository: supabase ? SupabaseMediaRepository() : null,
    // Memories persist in Supabase (public.memorise, protected by RLS).
    memoryRepository: supabase
        ? (auth, media) => SupabaseMemoryRepository(auth: auth, media: media)
        : null,
    // Open When / Waiting Messages in public.open_when (RLS).
    letterRepository: supabase
        ? (auth, media) => SupabaseLetterRepository(auth: auth, media: media)
        : null,
  );
  // Load the saved language before the first frame (no English flash).
  await dependencies.settings.load();
  runApp(MemoriesApp(dependencies: dependencies));
}
