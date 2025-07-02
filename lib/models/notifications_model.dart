enum NotificationType { system, promotion, groupPlayInvite, friendRequest }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String createdAt;
  final String message;
  final bool isHighlighted;

  NotificationItem({
    required this.type,
    required this.title,
    required this.createdAt,
    required this.message,
    this.isHighlighted = false,
  });
}
