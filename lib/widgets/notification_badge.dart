import 'package:flutter/material.dart';
import '../services/notification_service.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class NotificationBadge extends StatefulWidget {
  final Color iconColor;
  
  const NotificationBadge({
    super.key,
    this.iconColor = const Color(0xFF3C4554),
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  @override
  void initState() {
    super.initState();
    NotificationService.instance.loadRole();
  }

  Future<void> _openNotifications(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return ListenableBuilder(
          listenable: NotificationService(),
          builder: (BuildContext context, Widget? child) {
            final notifications = NotificationService().notifications;
            return Container(
              height: MediaQuery.of(sheetContext).size.height * 0.65,
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9DEE8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: notifications.isEmpty
                        ? const Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(color: _textSecondary),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            itemCount: notifications.length,
                            separatorBuilder: (context, index) => const Divider(height: 24, color: Color(0xFFE5E9F0)),
                            itemBuilder: (context, index) {
                              final notif = notifications[index];
                              return _NotificationItem(
                                title: notif['title']!,
                                time: notif['time']!,
                                content: notif['content']!,
                                isRead: notif['isRead'] == 'true',
                                onMarkAsRead: () {
                                  NotificationService().markAsRead(notif['id']!);
                                },
                                onDelete: () {
                                  NotificationService().delete(notif['id']!);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NotificationService.instance,
      builder: (BuildContext context, Widget? child) {
        final int count = NotificationService.instance.unreadCount;
        return IconButton(
          onPressed: () => _openNotifications(context),
          tooltip: 'Notifications',
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text(
              count.toString(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFE53935),
            offset: const Offset(4, -4),
            child: Icon(
              Icons.notifications_none_rounded,
              color: widget.iconColor,
            ),
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.title,
    required this.time,
    required this.content,
    required this.isRead,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  final String title;
  final String time;
  final String content;
  final bool isRead;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  void _showNotificationContent(BuildContext context) {
    onMarkAsRead();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: _primaryBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showNotificationContent(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isRead ? const Color(0xFFF0F3F8) : const Color(0xFFE8ECFF),
              child: Icon(
                Icons.notifications_active_outlined,
                color: isRead ? const Color(0xFF7C8798) : _primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isRead ? const Color(0xFF7C8798) : _textPrimary,
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: _textSecondary, size: 20),
              onSelected: (String value) {
                if (value == 'read') {
                  onMarkAsRead();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (!isRead)
                  const PopupMenuItem<String>(
                    value: 'read',
                    child: Text('Mark as read'),
                  ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete notification'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
