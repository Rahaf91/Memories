import '../repositories/notification_repository.dart';
import 'mock_data.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<int> getUnreadCount(String userId) async {
    await mockDelay();
    return 0;
  }
}
