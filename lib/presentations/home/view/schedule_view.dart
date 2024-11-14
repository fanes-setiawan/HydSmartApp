import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/presentations/widgets/text_switch_button.dart';
import 'package:hyd_smart_app/presentations/home/controller/schedule_controller.dart';
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api


class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late ScheduleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScheduleController(context: context, setState: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defauld,
      appBar: AppBar(
        backgroundColor: AppColors.defauld,
        title: const Text(
          'Add Schedule',
          style: TextStyle(
            color: AppColors.gray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_controller.selectedDay != null &&
              _controller.selectedTime != null)
            TextButton(
              onPressed: () {},
              child: const Text(
                "Tambahkan",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TableCalendar(
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.gray,
                  ),
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  dlg(day.toString());
                  return isSameDay(_controller.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _controller.selectedDay = null;
                    _controller.selectedTime = null;

                    _controller.selectedDay = selectedDay;
                    focusedDay = focusedDay;
                    _controller.selectTime();
                  });
                },
              ),
              if (_controller.selectedDay != null &&
                  _controller.selectedTime != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: AppColors.white),
                    child: Column(
                      children: [
                        const Text(
                          'Control',
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSwitchRow(
                          leading: Assets.icons.boxWire.svg(
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                          ),
                          title: "Automatic",
                          value: _controller.automatic,
                          onChanged: (value) async {
                            // _controller.setAutomatic(value);
                            // await _controller.updateSettings();
                          },
                        ),
                        const Divider(height: 0.1, thickness: 0.5),
                        TextSwitchRow(
                          leading: Assets.icons.fountain14SvgrepoCom.svg(
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                                AppColors.blue, BlendMode.srcIn),
                          ),
                          title: "Water Pump",
                          value: _controller.waterPump,
                          onChanged: (value) async {
                            // _controller.setWaterPump(value);
                            // await _controller.updateSettings();
                          },
                        ),
                        const Divider(height: 0.1, thickness: 0.5),
                        TextSwitchRow(
                          leading: Assets.icons.fanSvgrepoCom.svg(
                            width: 25,
                            height: 25,
                          ),
                          title: "Mixer",
                          value: _controller.mixer,
                          onChanged: (value) async {
                            // _controller.setMixer(value);
                            // await _controller.updateSettings();
                          },
                        ),
                        const Divider(height: 0.1, thickness: 0.5),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          // controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'tambahkan pH Up(ml)',
                            hintStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          // controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'tambahkan pH Down(ml)',
                            hintStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          // controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'tambahkan Nutrisi(ml)',
                            hintStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          // controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'tambahkan Air(ml)',
                            hintStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
