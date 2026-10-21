import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/data/mock/mock_chat_repository.dart';
import 'package:memories/models/app_user.dart';
import 'package:memories/models/chat_message.dart';
import 'package:memories/screens/chat/chat_list_screen.dart';
import 'package:memories/screens/chat/conversation_items.dart';
import 'package:memories/screens/chat/conversation_screen.dart';

import 'test_helpers.dart';

void main() {
  group('buildConversationItems', () {
    ChatMessage msg(String id, String sender, DateTime at) => ChatMessage(
      id: id,
      conversationId: 'c',
      senderId: sender,
      text: id,
      sentAt: at,
    );

    test('groups runs from one sender and separates days', () {
      final d1 = DateTime(2026, 10, 3, 10);
      final d2 = DateTime(2026, 10, 4, 9);
      final items = buildConversationItems([
        msg('a', 'me', d1),
        msg('b', 'me', d1.add(const Duration(minutes: 1))),
        msg('c', 'them', d1.add(const Duration(minutes: 2))),
        msg('d', 'them', d2),
      ], 'me');

      expect(items.map((i) => i.runtimeType), [
        DayItem,
        MessageItem,
        MessageItem,
        MessageItem,
        DayItem,
        MessageItem,
      ]);
      final m = items.whereType<MessageItem>().toList();
      expect([m[0].startsGroup, m[0].endsGroup], [true, false]);
      expect([m[1].startsGroup, m[1].endsGroup], [false, true]);
      expect(m[3].startsGroup, isTrue);
    });
  });

  test('incoming messages are unread until marked read', () async {
    final repo = MockChatRepository();
    const peer = AppUser(id: 'p', displayName: 'Peer');
    final convo = await repo.startConversation('me', peer);
    await repo.sendMessage(
      conversationId: convo.id,
      senderId: peer.id,
      text: 'Hi',
    );
    var list = await repo.watchConversations('me').first;
    expect(list.single.unreadCount, 1);
    await repo.markAsRead(convo.id, 'me');
    list = await repo.watchConversations('me').first;
    expect(list.single.unreadCount, 0);
  });

  testWidgets('empty chat → add friend → start chat → send, react, back', (
    tester,
  ) async {
    final deps = await pumpApp(tester);
    await openTab(tester, 'Chat');
    Finder inList(Finder f) =>
        find.descendant(of: find.byType(ChatListScreen), matching: f);

    expect(inList(find.text('No friends have checked in yet')), findsOneWidget);
    expect(inList(find.text('No conversations yet')), findsOneWidget);

    // Start Chat with no friends offers Add Friend.
    await tapIn(tester, ChatListScreen, 'Start Chat');
    expect(find.text('Start a chat'), findsOneWidget);
    expect(find.text('No friends added yet'), findsWidgets);
    await tester.tapAt(const Offset(200, 100)); // dismiss
    await tester.pumpAndSettle();

    await addFriend(tester, deps, 'Noor Hassan');
    await tapIn(tester, ChatListScreen, 'Start Chat');
    await tester.tap(find.text('Noor Hassan'));
    await tester.pumpAndSettle();
    expect(find.byType(ConversationScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Hello Noor');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Send'));
    await tester.pump();
    expect(find.text('Hello Noor'), findsOneWidget);
    expect(find.textContaining('Sending'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sent'), findsOneWidget);

    await tester.longPress(find.text('Hello Noor'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Agree'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.thumb_up_outlined), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Share in chat'));
    await tester.pumpAndSettle();
    for (final label in ['Add Memory', 'Send Open When', 'Waiting message']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();

    // Back returns to the chat list, which now shows the conversation.
    await tapBack(tester);
    expect(find.byType(ConversationScreen), findsNothing);
    expect(inList(find.text('No conversations yet')), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp(r'^Noor Hassan, You: Hello Noor')),
      findsOneWidget,
    );
    await settleTimers(tester);
  });
}
