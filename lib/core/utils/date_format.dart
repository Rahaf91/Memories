import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

// All date text follows the app language via [AppLocalizations.localeName].

/// "Sat, Oct 3"
String formatShortDate(AppLocalizations l, DateTime d) =>
    DateFormat.MMMEd(l.localeName).format(d);

/// "Saturday, October 3"
String formatLongDate(AppLocalizations l, DateTime d) =>
    DateFormat.MMMMEEEEd(l.localeName).format(d);

/// "Saturday, October 3, 2026"
String formatFullDate(AppLocalizations l, DateTime d) =>
    DateFormat.yMMMMEEEEd(l.localeName).format(d);

/// "October"
String monthName(AppLocalizations l, int month) =>
    DateFormat.MMMM(l.localeName).format(DateTime(2000, month));

/// Narrow month label: "J", "F", … (or the locale's equivalent).
String monthInitial(AppLocalizations l, int month) =>
    DateFormat('MMMMM', l.localeName).format(DateTime(2000, month));

/// "Sat, Oct 3, 9:41 AM"
String formatDateTime(AppLocalizations l, DateTime d) =>
    DateFormat.MMMEd(l.localeName).add_jm().format(d);

/// "9:41 AM"
String formatTime(AppLocalizations l, DateTime d) =>
    DateFormat.jm(l.localeName).format(d);

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

int _daysBetween(DateTime from, DateTime to) =>
    _day(to).difference(_day(from)).inDays;

/// "Just now", "5m ago", "2h ago", "Yesterday", "3d ago", "2w ago"
String timeAgo(AppLocalizations l, DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inMinutes < 1) return l.justNow;
  if (diff.inHours < 1) return l.minutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l.hoursAgo(diff.inHours);
  if (diff.inDays == 1) return l.yesterday;
  if (diff.inDays < 7) return l.daysAgo(diff.inDays);
  return l.weeksAgo(diff.inDays ~/ 7);
}

/// "today", "tomorrow", "in 8 days"
String formatDaysUntil(AppLocalizations l, DateTime target, {DateTime? now}) {
  final days = _daysBetween(now ?? DateTime.now(), target);
  if (days <= 0) return l.today;
  if (days == 1) return l.tomorrow;
  return l.inDays(days);
}

/// Time-of-day greeting with the user's name.
String greeting(AppLocalizations l, DateTime time, String name) {
  final h = time.hour;
  if (h >= 5 && h < 12) return l.greetingMorning(name);
  if (h >= 12 && h < 18) return l.greetingAfternoon(name);
  return l.greetingEvening(name);
}

/// Chat list time: clock time today, "Yesterday", weekday this week,
/// otherwise a short date.
String formatChatTime(AppLocalizations l, DateTime d, {DateTime? now}) {
  final days = _daysBetween(d, now ?? DateTime.now());
  if (days <= 0) return formatTime(l, d);
  if (days == 1) return l.yesterday;
  if (days < 7) return DateFormat.E(l.localeName).format(d);
  return DateFormat.MMMd(l.localeName).format(d);
}

/// Day separator in a conversation: "Today", "Yesterday", "Mon, Sep 28".
String formatChatDay(AppLocalizations l, DateTime d, {DateTime? now}) {
  final days = _daysBetween(d, now ?? DateTime.now());
  if (days <= 0) return l.today;
  if (days == 1) return l.yesterday;
  return formatShortDate(l, d);
}
