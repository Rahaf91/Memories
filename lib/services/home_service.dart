import '../data/repositories/auth_repository.dart';
import '../data/repositories/capsule_repository.dart';
import '../data/repositories/friend_repository.dart';
import '../data/repositories/letter_repository.dart';
import '../data/repositories/moment_repository.dart';
import '../data/repositories/mood_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/story_repository.dart';
import '../models/app_user.dart';
import '../models/friend_status.dart';
import '../models/moment.dart';
import '../models/mood.dart';
import '../models/scheduled_letter.dart';
import '../models/shared_capsule.dart';
import '../models/story.dart';

/// Everything the Home screen needs, loaded in one go.
class HomeData {
  const HomeData({
    required this.user,
    required this.todayMood,
    required this.stories,
    required this.friends,
    required this.posts,
    required this.featuredOpenWhen,
    required this.capsules,
    required this.unreadNotifications,
    this.scheduledLetters = const [],
    this.inboxLetters = const [],
    this.waitingMessages = const [],
  });

  final AppUser user;
  final Mood? todayMood;
  final List<Story> stories;
  final List<FriendStatus> friends;

  /// Shared-memory moments shown as photo cards.
  final List<Moment> posts;

  /// The next unopened "Open When" letter, highlighted on Home.
  final Moment? featuredOpenWhen;
  final List<SharedCapsule> capsules;
  final int unreadNotifications;

  /// Open When letters the user has written, soonest first.
  final List<ScheduledLetter> scheduledLetters;

  /// Open When letters addressed to the user (incl. to their future self).
  final List<ScheduledLetter> inboxLetters;

  /// Waiting Messages the user wrote or received.
  final List<ScheduledLetter> waitingMessages;

  HomeData copyWith({List<Moment>? posts}) => HomeData(
    user: user,
    todayMood: todayMood,
    stories: stories,
    friends: friends,
    posts: posts ?? this.posts,
    featuredOpenWhen: featuredOpenWhen,
    capsules: capsules,
    unreadNotifications: unreadNotifications,
    scheduledLetters: scheduledLetters,
    inboxLetters: inboxLetters,
    waitingMessages: waitingMessages,
  );
}

/// Composes repositories into Home-screen use cases.
///
/// Screens talk to services; services talk to repositories. Swapping the
/// mock repositories for real ones requires no change here.
class HomeService {
  HomeService({
    required this._auth,
    required this._moods,
    required this._friends,
    required this._moments,
    required this._stories,
    required this._capsules,
    required this._notifications,
    required this._letters,
  });

  final AuthRepository _auth;
  final MoodRepository _moods;
  final FriendRepository _friends;
  final MomentRepository _moments;
  final StoryRepository _stories;
  final CapsuleRepository _capsules;
  final NotificationRepository _notifications;
  final LetterRepository _letters;

  Future<HomeData> loadHome() async {
    final user = await _auth.getCurrentUser();
    if (user == null) {
      throw StateError('No signed-in user');
    }

    final (
      moodEntry,
      stories,
      friends,
      moments,
      capsules,
      unread,
      letters,
      inbox,
      allLetters,
    ) = await (
      _moods.getTodayMood(user.id),
      _stories.getRecentStories(user.id),
      _friends.getFriendsToday(user.id),
      _moments.getRecentMoments(user.id),
      _capsules.getCapsules(user.id),
      _notifications.getUnreadCount(user.id),
      _letters.getScheduledLetters(user.id),
      _letters.getInbox(user.id),
      _letters.getLetters(user.id),
    ).wait;

    final openWhen = moments
        .where((m) => m.type == MomentType.openWhen && !m.isOpened)
        .toList();

    return HomeData(
      user: user,
      todayMood: moodEntry?.mood,
      stories: stories,
      friends: friends,
      posts: moments.where((m) => m.type == MomentType.sharedMemory).toList(),
      featuredOpenWhen: openWhen.isEmpty ? null : openWhen.first,
      capsules: capsules,
      unreadNotifications: unread,
      // Letters to others that haven't unlocked yet; self-letters show in
      // the inbox instead.
      inboxLetters: inbox.where((l) => l.kind == LetterKind.openWhen).toList(),
      waitingMessages: allLetters
          .where((l) => l.kind == LetterKind.message)
          .toList(),
      scheduledLetters: letters
          .where(
            (l) =>
                l.kind == LetterKind.openWhen &&
                !l.isToSelf &&
                l.openAt.isAfter(DateTime.now()),
          )
          .toList(),
    );
  }

  Future<void> setTodayMood(String userId, Mood mood) =>
      _moods.setTodayMood(userId, mood);

  Future<void> setReaction(
    String momentId,
    String userId, {
    required bool reacted,
  }) => _moments.setReaction(momentId, userId, reacted: reacted);
}
