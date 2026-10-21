import 'app_user.dart';

/// Where a letter is in its life, as seen by its recipient.
enum LetterState {
  /// Before [ScheduledLetter.openAt]: content stays sealed.
  locked,

  /// [ScheduledLetter.openAt] has passed; not opened yet.
  ready,

  /// Client-only, transient: the first-opening reveal is playing. Never
  /// stored; ends in [opened] once the reveal completes.
  opening,

  /// Opened at least once ([ScheduledLetter.openedAt] is set).
  opened,
}

/// What kind of scheduled message this is.
enum LetterKind {
  /// "Open when…" letter: [ScheduledLetter.title] completes the phrase.
  openWhen('open_when'),

  /// A Waiting Message with a free-form title.
  message('message');

  const LetterKind(this.value);

  /// Stable identifier stored in the database.
  final String value;

  static LetterKind fromValue(String? value) => LetterKind.values.firstWhere(
    (k) => k.value == value,
    orElse: () => LetterKind.openWhen,
  );
}

/// A scheduled message ("Open When" letter or Waiting Message), sealed
/// until [openAt].
///
/// Stored fields: recipient, title, body (message), imageUrls (path/url),
/// openAt (scheduled date/time), status, createdAt, openedAt. Only the
/// opened/not-opened part of the status is stored; locked vs ready is
/// always derived from [openAt] and the current time.
class ScheduledLetter {
  const ScheduledLetter({
    required this.id,
    required this.author,
    required this.recipient,
    required this.title,
    required this.body,
    required this.openAt,
    required this.createdAt,
    this.kind = LetterKind.openWhen,
    this.note,
    this.openedAt,
    this.imageUrls = const [],
    this.audioUrl,
    this.audioDuration,
  });

  final String id;
  final AppUser author;
  final AppUser recipient;

  /// Completes "Open when…", e.g. "you need a reminder of who you are".
  final String title;
  final String body;
  final DateTime openAt;
  final DateTime createdAt;
  final LetterKind kind;

  /// Optional private note (only the author sees it).
  final String? note;

  /// When the recipient first opened it; null until then.
  final DateTime? openedAt;

  /// Optional photos, revealed before the text.
  final List<String> imageUrls;

  /// Optional voice note (not supported in the UI yet beyond a placeholder).
  final String? audioUrl;
  final Duration? audioDuration;

  /// A letter the user wrote to their future self.
  bool get isToSelf => author.id == recipient.id;

  /// Stored state at [now]. Never returns [LetterState.opening].
  LetterState stateAt(DateTime now) {
    if (openedAt != null) return LetterState.opened;
    return now.isBefore(openAt) ? LetterState.locked : LetterState.ready;
  }

  ScheduledLetter copyWith({DateTime? openedAt}) => ScheduledLetter(
    id: id,
    author: author,
    recipient: recipient,
    title: title,
    body: body,
    openAt: openAt,
    createdAt: createdAt,
    kind: kind,
    note: note,
    openedAt: openedAt ?? this.openedAt,
    imageUrls: imageUrls,
    audioUrl: audioUrl,
    audioDuration: audioDuration,
  );

  factory ScheduledLetter.fromMap(Map<String, dynamic> map) => ScheduledLetter(
    id: map['id'] as String,
    author: AppUser.fromMap(map['author'] as Map<String, dynamic>),
    recipient: AppUser.fromMap(map['recipient'] as Map<String, dynamic>),
    title: map['title'] as String,
    body: map['body'] as String,
    openAt: DateTime.parse(map['open_at'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
    kind: LetterKind.fromValue(map['kind'] as String?),
    note: map['note'] as String?,
    openedAt: map['opened_at'] == null
        ? null
        : DateTime.parse(map['opened_at'] as String),
    imageUrls: List<String>.from(map['image_urls'] as List? ?? const []),
    audioUrl: map['audio_url'] as String?,
    audioDuration: map['audio_duration_ms'] == null
        ? null
        : Duration(milliseconds: map['audio_duration_ms'] as int),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'author': author.toMap(),
    'recipient': recipient.toMap(),
    'title': title,
    'body': body,
    'open_at': openAt.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'kind': kind.value,
    // Persisted status: 'opened' once opened, otherwise 'scheduled'.
    'status': openedAt != null ? 'opened' : 'scheduled',
    'note': note,
    'opened_at': openedAt?.toIso8601String(),
    'image_urls': imageUrls,
    'audio_url': audioUrl,
    'audio_duration_ms': audioDuration?.inMilliseconds,
  };
}
