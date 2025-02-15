import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/presentations/remote/controller/calibration_controller.dart';
// ignore_for_file: use_super_parameters
// ignore_for_file: must_be_immutable
// ignore_for_file: public_member_api_docs, sort_constructors_first

class CalibrationView extends StatefulWidget {
  String sensorName;
  CalibrationView({
    Key? key,
    required this.sensorName,
  }) : super(key: key);
  @override
  State<CalibrationView> createState() => _CalibrationViewState();
}

class _CalibrationViewState extends State<CalibrationView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalibrationController(sensorName: widget.sensorName),
      child: Consumer<CalibrationController>(
        builder: (context, controller, child) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                if (controller.step == 1)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: controller.step == 1
                      ? _buildStep1(context, controller)
                      : _buildStep2(context, controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep1(BuildContext context, CalibrationController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kalibrasi Sensor ${widget.sensorName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text(
          'Masukkan Nilai Larutan Standar!!!',
          style: TextStyle(fontSize: 12.0),
        ),
        const SizedBox(height: 20),
        widget.sensorName == 'tds'
            ? SizedBox(
                height: 40,
                child: TextField(
                  controller: controller.controllerText,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0 ppm',
                    hintStyle:
                        TextStyle(color: AppColors.black.withOpacity(0.6)),
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
                  onChanged: (value) {
                    setState(() {
                      controller.isInputValid = value.isNotEmpty;
                    });
                  },
                ),
              )
            : Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.liquor),
                    label: const Text("4.01 pH"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: () {
                        controller.nextStep();
                      controller.startCountdown(
                          () => Navigator.of(context).pop(), 4.01);
                    },
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.liquor),
                    label: const Text("6.86 pH"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: () {
                      controller.nextStep();
                      controller.startCountdown(
                          () => Navigator.of(context).pop(), 6.86);
                    },
                  ),
                ],
              ),
        if (controller.controllerText.text.isNotEmpty)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                controller.nextStep();
                controller.startCountdown(
                    () => Navigator.of(context).pop(), null);
              },
              child: const Text("Lanjut"),
            ),
          )
      ],
    );
  }

  Widget _buildStep2(BuildContext context, CalibrationController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Masukkan probe ke larutan standar!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: 0.0),
          duration: const Duration(seconds: 10),
          builder: (context, double value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.red),
                  ),
                ),
                Text(
                  "${controller.counter}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

void showCalibrationDialog(BuildContext context, String sensor) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CalibrationView(
      sensorName: sensor,
    ),
  );
}
