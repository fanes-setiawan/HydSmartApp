import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';

class NotifView extends StatefulWidget {
  const NotifView({super.key});

  @override
  State<NotifView> createState() => _NotifViewState();
}

class _NotifViewState extends State<NotifView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          actions: const [],
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
            String? lastDisplayedDate;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final notificationDate = FormatTime.formatDate(
                    DateTime.parse(notification['timestamp']));
                bool showDateHeader = lastDisplayedDate != notificationDate;
                if (showDateHeader) {
                  lastDisplayedDate = notificationDate;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Text(
                        notificationDate,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray,
                        ),
                      ),
                    ListTile(
                      selectedTileColor: notification['isRead'] == 0
                          ? AppColors.blue.withOpacity(0.2)
                          : AppColors.stroke, // Warna saat dipilih
                      selected: true, // Atur true untuk efek seleksi
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Assets.logo.logoNbg.svg(),
                      ),
                      title: Row(
                        children: [
                          Text(notification['title'] ?? ''),
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
                  ],
                );
              },
            );
          },
        ));
  }
}
