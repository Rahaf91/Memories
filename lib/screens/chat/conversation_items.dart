import '../../models/chat_message.dart';

/// A row in the conversation view: a day separator or a message.
sealed class ConversationItem {
  const ConversationItem();
}

class DayItem extends ConversationItem {
  const DayItem(this.day);
  final DateTime day;
}

class MessageItem extends ConversationItem {
  const MessageItem({
    required this.message,
    required this.isMine,
    required this.startsGroup,
    required this.endsGroup,
  });

  final ChatMessage message;
  final bool isMine;
  final bool startsGroup;
  final bool endsGroup;
}

/// Messages from the same sender within this gap are grouped together.
const groupingGap = Duration(minutes: 5);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool _grouped(ChatMessage a, ChatMessage b) =>
    a.senderId == b.senderId &&
    _sameDay(a.sentAt, b.sentAt) &&
    b.sentAt.difference(a.sentAt).abs() <= groupingGap;

/// Turns oldest-first [messages] into display rows: day separators plus
/// messages annotated with their position in a sender group.
List<ConversationItem> buildConversationItems(
  List<ChatMessage> messages,
  String viewerId,
) {
  final items = <ConversationItem>[];
  for (var i = 0; i < messages.length; i++) {
    final m = messages[i];
    final prev = i > 0 ? messages[i - 1] : null;
    final next = i < messages.length - 1 ? messages[i + 1] : null;

    if (prev == null || !_sameDay(prev.sentAt, m.sentAt)) {
      items.add(DayItem(m.sentAt));
    }
    items.add(
      MessageItem(
        message: m,
        isMine: m.isFrom(viewerId),
        startsGroup: prev == null || !_grouped(prev, m),
        endsGroup: next == null || !_grouped(m, next),
      ),
    );
  }
  return items;
}
