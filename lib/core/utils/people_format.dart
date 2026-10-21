import '../../l10n/app_localizations.dart';
import '../../models/app_user.dart';

/// "Alex", "Alex & Sam", "3 friends", or [empty] (default "Only you").
String formatPeople(AppLocalizations l, List<AppUser> people, {String? empty}) {
  return switch (people.length) {
    0 => empty ?? l.onlyYou,
    1 => people.first.firstName,
    2 => l.peopleTwo(people[0].firstName, people[1].firstName),
    _ => l.peopleMany(people.length),
  };
}
