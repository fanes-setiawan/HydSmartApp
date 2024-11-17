import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';
import 'package:hyd_smart_app/common/message/showTopSnackBarWithActions.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CardScheduleWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function()? onDelete;

  const CardScheduleWidget({
    super.key,
    required this.data,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    final settings = data['settings'] as Map<String, dynamic>;

    // Filter settings untuk hanya menampilkan key yang memiliki nilai
    final filteredSettings = settings.entries
        .where(
            (entry) => entry.value != null && entry.value.toString().isNotEmpty)
        .toList();

    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Assets.icons.clock.svg(
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  FormatTime.FormatTimes(data['scheduled_time']),
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showTopSnackBarWithActions(
                      context: context,
                      title: 'Delete Schedule',
                      message: 'apakah anda yakin ingin menghapus jadwal ini?',
                      textButton1: 'Cancel',
                      textButton2: 'Delete',
                      tapButton2:  onDelete,
                    );
                  },
                  icon: Assets.icons.trash.svg(
                    width: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Scrollbar(
                 thumbVisibility: true, 
        controller: _scrollController, // Berikan ScrollController
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredSettings.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                            ),
                            Text(
                              entry.value.toString(),
                              style: const TextStyle(color: AppColors.gray),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
