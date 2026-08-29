import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _notifications = NotificationItem.getSampleNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification.isRead = true;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    backgroundColor: Color(0xFF0D1B2A),
                  ),
                );
              },
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 50,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'re all caught up! Check back later for updates on campaigns, donations, and volunteer opportunities.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Georgia',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color iconColor;
    IconData iconData;

    switch (notification.type) {
      case 'donation':
        iconColor = Colors.green;
        iconData = Icons.money;
        break;
      case 'campaign':
        iconColor = const Color(0xFFD4AF37);
        iconData = Icons.campaign;
        break;
      case 'volunteer':
        iconColor = Colors.blue;
        iconData = Icons.volunteer_activism;
        break;
      case 'impact':
        iconColor = Colors.purple;
        iconData = Icons.insights;
        break;
      default:
        iconColor = Colors.grey;
        iconData = Icons.notifications;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(iconData, color: iconColor, size: 22),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
            color: const Color(0xFF0D1B2A),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 13,
                color: Color(0xFF4A5A6A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimeAgo(notification.createdAt),
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 11,
                color: Color(0xFF4A5A6A),
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: notification.isRead
            ? null
            : Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          // Navigate to relevant screen based on type
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} months ago';
    } else if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  static List<NotificationItem> getSampleNotifications() {
    return [
      NotificationItem(
        id: '1',
        type: 'donation',
        title: 'Donation Successful!',
        message:
            'Your donation of ₦10,000 to "Build Digital Skills Centre" was successful.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        type: 'campaign',
        title: 'Campaign Update',
        message:
            '"Vocational Training Equipment" has reached 60% of its funding goal.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        type: 'impact',
        title: 'Impact Report Available',
        message:
            'Digital Skills Centre has published its latest impact report.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        type: 'volunteer',
        title: 'Volunteer Application Update',
        message:
            'Your application for "Digital Skills Trainer" has been reviewed.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        type: 'campaign',
        title: 'Campaign Funded!',
        message: '"Educational Materials for Prisoners" has been fully funded!',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isRead: true,
      ),
    ];
  }
}
