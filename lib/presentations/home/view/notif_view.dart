import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';
import 'package:hyd_smart_app/common/message/showTopSnackBarWithActions.dart';

class NotifView extends StatefulWidget {
  const NotifView({super.key});

  @override
  State<NotifView> createState() => _NotifViewState();
}

class _NotifViewState extends State<NotifView> {
  int dataNotificationLength = 0;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    final notifications = await DBHelper().getAllNotifications().first;
    if (mounted) {
      setState(() {
        dataNotificationLength = notifications.length;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    DBHelper().markAllNotificationsAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stroke,
      appBar: AppBar(
        backgroundColor: AppColors.stroke,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.gray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          dataNotificationLength > 0
              ? CircleAvatar(
                  backgroundColor: AppColors.defauld,
                  child: IconButton(
                    onPressed: () => _showDeleteConfirmDialog(),
                    icon: Icon(
                      Icons.delete,
                      size: 24.0,
                      color: AppColors.red.withOpacity(0.8),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 10)
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: DBHelper().getAllNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(child: Text("Tidak ada notifikasi"));
          }
          return _buildNotificationList(notifications);
        },
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showTopSnackBarWithActions(
      context: context,
      title: 'Delete History Notifikasi',
      message: 'Apakah Anda yakin ingin menghapus semua history?',
      textButton1: 'Cancel',
      textButton2: 'Delete',
      tapButton2: () {
        DBHelper().deleteAllNotifications();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    String? lastDisplayedDate;
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final notificationDate =
            FormatTime.formatDate(DateTime.parse(notification['timestamp']));
        bool showDateHeader = lastDisplayedDate != notificationDate;
        if (showDateHeader) {
          lastDisplayedDate = notificationDate;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  notificationDate,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray,
                  ),
                ),
              ),
            Dismissible(
              key: Key(notification['id'].toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: AppColors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                DBHelper().deleteNotification(notification['id']);
                notifications.removeAt(index);
              },
              child: ListTile(
                selectedTileColor: notification['isRead'] == 0
                    ? AppColors.blue.withOpacity(0.2)
                    : AppColors.stroke,
                selected: true,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Assets.logo.logoNbg.svg(),
                ),
                title: Row(
                  children: [
                    Expanded(child: Text(notification['title'] ?? '')),
                    Assets.icons.bell.svg(),
                  ],
                ),
                subtitle: Text(
                  notification['body'] ?? '',
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  FormatTime.FormatTimes(
                    DateTime.parse(notification['timestamp']),
                  ),
                ),
                onTap: () {
                  DBHelper().markNotificationAsRead(notification['id']);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
