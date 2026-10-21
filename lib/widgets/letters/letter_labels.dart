import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';

/// Display text for a scheduled letter, by kind and by who's looking.
extension LetterLabels on ScheduledLetter {
  /// "Open When" / "Waiting message".
  String overline(AppLocalizations l) => switch (kind) {
    LetterKind.openWhen => l.openWhenTitle,
    LetterKind.message => l.waitingMessageOverline,
  };

  /// "Open when you need a pause" or the message's own title.
  String headline(AppLocalizations l) => switch (kind) {
    LetterKind.openWhen => l.openWhenPhrase(title),
    LetterKind.message => title,
  };

  /// The other person, from [viewerId]'s side: "To future you", "To Noor",
  /// "From Noor".
  String counterpart(AppLocalizations l, String viewerId) {
    if (isToSelf) {
      return kind == LetterKind.message ? l.toFutureYou : l.fromYou;
    }
    return author.id == viewerId
        ? l.toName(recipient.firstName)
        : l.fromName(author.firstName);
  }
}
