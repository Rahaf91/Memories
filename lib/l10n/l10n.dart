import 'package:flutter/widgets.dart';

import '../models/memory.dart';
import '../models/memory_filter.dart';
import '../models/message_reaction.dart';
import '../models/mood.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  /// Localized strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// True when the current layout is right-to-left (e.g. Arabic).
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
}

/// Localized labels for model enums. Models stay UI-free; their English
/// `label` fields are only fallbacks.
extension L10nLabels on AppLocalizations {
  String mood(Mood m) => switch (m) {
    Mood.amazing => moodAmazing,
    Mood.good => moodGood,
    Mood.okay => moodOkay,
    Mood.sad => moodSad,
    Mood.veryBad => moodVeryBad,
  };

  String memoryFilter(MemoryFilter f) => switch (f) {
    MemoryFilter.all => filterAll,
    MemoryFilter.friends => filterFriends,
    MemoryFilter.shared => filterShared,
    MemoryFilter.capsules => filterCapsules,
  };

  String visibility(MemoryVisibility v) => switch (v) {
    MemoryVisibility.private => visibilityPrivate,
    MemoryVisibility.friends => visibilityFriends,
    MemoryVisibility.shared => visibilityShared,
    MemoryVisibility.capsule => visibilityCapsule,
  };

  String reaction(ReactionType r) => switch (r) {
    ReactionType.love => reactionLove,
    ReactionType.agree => reactionAgree,
    ReactionType.haha => reactionHaha,
    ReactionType.sad => reactionSad,
  };
}
