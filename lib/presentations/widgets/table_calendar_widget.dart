import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';

class TableCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime selectedDay, DateTime focusedDay)?
      onDayLongPressed;
  final Map<DateTime, List<dynamic>> events;

  const TableCalendarWidget({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    this.onDayLongPressed,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppColors.primary,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.gray,
        ),
        markerDecoration: BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,
        ),
        disabledDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.red,
        ),
      ),
      eventLoader: (date) {
        return events[DateTime(date.year, date.month, date.day)] ?? [];
      },
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) {
        return selectedDay != null && isSameDay(selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay, focusedDay);
      },
      onDayLongPressed: onDayLongPressed,
    );
  }
}
