import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';
import 'package:hyd_smart_app/core/model/combineDateAndTime.dart';
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

  bool automatic = false;
  bool waterPump = false;
  bool mixer = false;

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
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
    dlg("HASIL TIME PICKER ${pickedTime.toString()}");
    dlg("HASIL TIME PICKER DAY${selectedDay.toString()}");
    if (selectedDay != null && selectedTime != null) {
      // Gabungkan tanggal dan waktu
      DateTime combinedDateTime =
          combineDateAndTime(selectedDay!, selectedTime!);

      // Format tanggal untuk tampilanß
      String formattedDate = FormatTime.formatDateTime(combinedDateTime);
      dlg("Formatted Date: $formattedDate");

      // Konversi ke Firestore Timestamp
      Timestamp firestoreTimestamp = FormatTime.toFirestoreTimestamp(dateTime:  combinedDateTime);
      dlg("Firestore Timestamp: $firestoreTimestamp");

      // Post ke Firestore
      await addSchedule(scheduledTime: firestoreTimestamp);
    }
  }


  
  Future<void> addSchedule({required Timestamp scheduledTime, Map<String, dynamic>? settings}) async {
  try {
    // Hapus field null dalam map settings
    settings?.removeWhere((key, value) => value == null);

    await FirebaseFirestore.instance.collection('schedule').add({
      'isRun': false, // Default value untuk isRun
      'scheduled_time': scheduledTime,
      'settings': settings,
    });

    dlg("Data berhasil dikirim ke Firestore!");
  } catch (e) {
    dlg("Error saat mengirim ke Firestore: $e");
  }
}

}
