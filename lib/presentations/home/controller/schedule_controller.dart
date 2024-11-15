import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/core/format/format_time.dart';
import 'package:hyd_smart_app/core/model/combineDateAndTime.dart';
import 'package:hyd_smart_app/common/message/showTopSnackBar.dart';
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
  }

  Future<void> addSchedule() async {
    try {
      // Validasi bahwa tanggal dan waktu telah dipilih
      if (selectedDay != null && selectedTime != null) {
        // Gabungkan tanggal dan waktu
        DateTime combinedDateTime =
            combineDateAndTime(selectedDay!, selectedTime!);
        Timestamp firestoreTimestamp =
            FormatTime.toFirestoreTimestamp(dateTime: combinedDateTime);

        dlg("Firestore Timestamp: $firestoreTimestamp");

        // Buat settings map dan hapus field yang null atau kosong
        Map<String, dynamic> settings = {
          'auto': automatic,
          'waterPump': waterPump,
          'mixer': mixer,
          'phUp': controllerPhUp.text.isNotEmpty ? controllerPhUp.text : null,
          'phDown':
              controllerPhDown.text.isNotEmpty ? controllerPhDown.text : null,
          'nutrisi':
              controllerNutrisi.text.isNotEmpty ? controllerNutrisi.text : null,
          'water':
              controllerWater.text.isNotEmpty ? controllerWater.text : null,
        };

        // Hapus nilai null dari map settings
        settings.removeWhere((key, value) => value == null);

        // Kirim data ke Firestore
        await FirebaseFirestore.instance.collection('schedule').add({
          'isRun': false, // Default value untuk isRun
          'scheduled_time': firestoreTimestamp,
          'settings': settings,
        });

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
}
