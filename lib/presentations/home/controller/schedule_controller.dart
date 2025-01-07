import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';
import 'package:hyd_smart_app/core/model/combineDateAndTime.dart';
import 'package:hyd_smart_app/common/message/showTopSnackBar.dart';
// ignore_for_file: use_build_context_synchronously

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ScheduleController {
  late BuildContext context;
  void Function(void Function()) setState;
  ScheduleController({
    required this.context,
    required this.setState,
  });

  DateTime? selectedDay;
  TimeOfDay? selectedTime;

  //settings
  bool automatic = false;
  bool waterPump = false;
  bool mixer = false;

  final TextEditingController controllerPhUp = TextEditingController();
  final TextEditingController controllerPhDown = TextEditingController();
  final TextEditingController controllerNutrisi = TextEditingController();
  final TextEditingController controllerWater = TextEditingController();

  List<Map<String, dynamic>> settingEvent = [];
  List<Map<String, dynamic>> allEvents = [];

  // Tambahkan metode untuk mengubah nilai
  void setAutomatic(bool value) {
    setState(() {
      automatic = value;
    });
  }

  void setWaterPump(bool value) {
    setState(() {
      waterPump = value;
    });
  }

  void setMixer(bool value) {
    setState(() {
      mixer = value;
    });
  }

  clearDataInput() {
    controllerPhUp.clear();
    controllerPhDown.clear();
    controllerNutrisi.clear();
    controllerWater.clear();
    waterPump = false;
    mixer = false;
  }

  Stream<Map<DateTime, List<Map<String, dynamic>>>> getEventsMap() {
    return FirebaseFirestore.instance
        .collection('schedule')
        .snapshots()
        .map((snapshot) {
      Map<DateTime, List<Map<String, dynamic>>> events = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final scheduledTime = (data['scheduled_time'] as Timestamp).toDate();
        final dateKey = DateTime(
            scheduledTime.year, scheduledTime.month, scheduledTime.day);

        if (events[dateKey] == null) {
          events[dateKey] = [];
        }
        events[dateKey]!.add({
          'id': doc.id,
          'scheduled_time': scheduledTime,
          'settings': data['settings'] ?? {},
        });
        allEvents.add({
          'id': doc.id,
          'scheduled_time': scheduledTime,
          'settings': data['settings'] ?? {},
        });
      }

      return events;
    });
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      barrierDismissible: false,
      context: context,
      barrierLabel: 'Time Schedule',
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> addSchedule() async {
    try {
      if (selectedDay != null && selectedTime != null) {
        // Gabungkan tanggal dan waktu
        DateTime combinedDateTime =
            combineDateAndTime(selectedDay!, selectedTime!);
        Timestamp firestoreTimestamp =
            FormatTime.toFirestoreTimestamp(dateTime: combinedDateTime);

        // Buat settings map dan hapus field yang null atau kosong
        Map<String, dynamic> settings = {
          'auto': automatic,
          'waterPump': waterPump,
          'mixer': mixer,
          'phUp': controllerPhUp.text,
          'phDown': controllerPhDown.text,
          'nutrisi':controllerNutrisi.text,
          'water': controllerWater.text,
        };

        // Hapus nilai null dari map settings
        settings.removeWhere((key, value) => value == null);

        // Kirim data ke Firestore
        await FirebaseFirestore.instance.collection('schedule').add({
          'isRun': false,
          'scheduled_time': firestoreTimestamp,
          'settings': settings,
        });
        selectedTime = null;
        setState(() {});
        settings.clear();
        clearDataInput();

        showTopSnackBar(
          context: context,
          title: 'Hydroponik Smart',
          message: 'Schedule berhasil ditambahkan',
        );

        dlg("Data berhasil dikirim ke Firestore!");
      } else {
        dlg("Tanggal atau waktu belum dipilih!");
      }
    } catch (e) {
      dlg("Error saat mengirim ke Firestore: ${e.toString()}");
    }
  }

  void getSettings(Map<DateTime, List<Map<String, dynamic>>> events) {
    DateTime day = selectedDay ?? DateTime.now();
    settingEvent.clear();

    for (var key in events.keys) {
      final List<Map<String, dynamic>> eventList = events[key] ?? [];
      for (var event in eventList) {
        if (event['scheduled_time'] != null) {
          DateTime eventDateTime;
          if (event['scheduled_time'] is Timestamp) {
            eventDateTime = (event['scheduled_time'] as Timestamp).toDate();
          } else {
            eventDateTime = event['scheduled_time'] as DateTime;
          }

          if (FormatTime.formatDate(day) ==
              FormatTime.formatDate(eventDateTime)) {
            settingEvent.add(event);
          }
        }
      }
    }
  }

  void deleteSchedule(String id) async {
    await FirebaseFirestore.instance.collection('schedule').doc(id).delete();
    showTopSnackBar(
      context: context,
      title: 'Hydroponik Smart',
      message: 'Schedule berhasil dihapus',
    );
  }
}
