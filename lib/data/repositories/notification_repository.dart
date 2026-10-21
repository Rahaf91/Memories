abstract interface class NotificationRepository {
  Future<int> getUnreadCount(String userId);
}
