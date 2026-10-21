import 'package:flutter/widgets.dart';

import '../core/clock.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/letter_repository.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/memory_repository.dart';
import '../data/mock/in_memory_settings_repository.dart';
import '../data/mock/local_media_repository.dart';
import '../data/mock/mock_auth_repository.dart';
import '../data/mock/mock_capsule_repository.dart';
import '../data/mock/mock_chat_repository.dart';
import '../data/mock/mock_friend_repository.dart';
import '../data/mock/mock_letter_repository.dart';
import '../data/mock/mock_memory_repository.dart';
import '../data/mock/mock_moment_repository.dart';
import '../data/mock/mock_mood_repository.dart';
import '../data/mock/mock_notification_repository.dart';
import '../data/mock/mock_story_repository.dart';
import '../services/auth_controller.dart';
import '../services/chat_service.dart';
import '../services/create_service.dart';
import '../services/data_changes.dart';
import '../services/friends_service.dart';
import '../services/home_service.dart';
import '../services/letters_service.dart';
import '../services/media_picker.dart';
import '../services/memories_service.dart';
import '../services/settings_controller.dart';

/// Composition root: the only place that decides which implementations
/// the app uses. To connect a backend, construct Supabase/Firebase
/// repositories here instead of the local ones.
class AppDependencies {
  AppDependencies._({
    required this.homeService,
    required this.memoriesService,
    required this.createService,
    required this.chatService,
    required this.friendsService,
    required this.lettersService,
    required this.clock,
    required this.mediaPicker,
    required this.auth,
    required this.settings,
    required this.dataChanges,
  });

  /// Local, in-memory data (no friends, memories, conversations, or
  /// check-ins yet). [authRepository] decides who is signed in: Supabase
  /// Auth in the app, a local account by default.
  factory AppDependencies.local({
    Clock clock = const Clock(),
    MediaPicker? mediaPicker,
    AuthRepository? authRepository,
    MemoryRepository Function(AuthRepository auth, MediaRepository media)?
    memoryRepository,
    LetterRepository Function(AuthRepository auth, MediaRepository media)?
    letterRepository,
    MediaRepository? mediaRepository,
  }) {
    // Shared instances so every service sees the same data.
    final changes = DataChanges();
    // Supabase Auth in the app; the local account in tests/offline.
    final auth = authRepository ?? MockAuthRepository();
    final moods = MockMoodRepository();
    final friends = MockFriendRepository();
    // Supabase in the app; in-memory in tests/offline.
    // Photos: Supabase Storage in the app; the device in tests/offline.
    final media = mediaRepository ?? LocalMediaRepository();
    final memories =
        memoryRepository?.call(auth, media) ?? MockMemoryRepository();
    final capsules = MockCapsuleRepository();
    // Supabase in the app; in-memory in tests/offline.
    final letters =
        letterRepository?.call(auth, media) ?? MockLetterRepository();

    return AppDependencies._(
      dataChanges: changes,
      clock: clock,
      auth: AuthController(auth),
      mediaPicker: mediaPicker ?? DeviceMediaPicker(),
      lettersService: LettersService(
        letters: letters,
        changes: changes,
        clock: clock,
      ),
      settings: SettingsController(InMemorySettingsRepository()),
      homeService: HomeService(
        auth: auth,
        moods: moods,
        friends: friends,
        moments: MockMomentRepository(),
        stories: MockStoryRepository(),
        capsules: capsules,
        notifications: MockNotificationRepository(),
        letters: letters,
      ),
      memoriesService: MemoriesService(
        auth: auth,
        memories: memories,
        moods: moods,
      ),
      chatService: ChatService(
        auth: auth,
        chat: MockChatRepository(),
        friends: friends,
      ),
      friendsService: FriendsService(
        auth: auth,
        friends: friends,
        memories: memories,
        changes: changes,
      ),
      createService: CreateService(
        auth: auth,
        friends: friends,
        memories: memories,
        letters: letters,
        moods: moods,
        changes: changes,
        clock: clock,
        media: media,
      ),
    );
  }

  final HomeService homeService;
  final MemoriesService memoriesService;
  final CreateService createService;
  final ChatService chatService;
  final FriendsService friendsService;
  final LettersService lettersService;

  /// Source of "now" for time-driven UI (letters unlocking).
  final Clock clock;

  /// Photo picking (swappable in tests).
  final MediaPicker mediaPicker;

  /// Who is signed in; the app shows the sign-in screen when nobody is.
  final AuthController auth;

  /// Language and other preferences.
  final SettingsController settings;

  /// Fires when any service creates or updates data.
  final DataChanges dataChanges;
}

/// Makes [AppDependencies] available to the widget tree.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.dependencies, required super.child});

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}
