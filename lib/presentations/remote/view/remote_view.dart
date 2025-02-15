import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/common/widgets/button_ex.dart';
import 'package:hyd_smart_app/common/widgets/card_widget.dart';
import 'package:hyd_smart_app/common/widgets/text_input_button.dart';
import 'package:hyd_smart_app/common/widgets/text_switch_button.dart';
import 'package:hyd_smart_app/presentations/remote/view/calibration_view.dart';
import 'package:hyd_smart_app/presentations/remote/controller/remote_controller.dart';

class RemoteView extends StatefulWidget {
  const RemoteView({super.key});

  @override
  State<RemoteView> createState() => _RemoteViewState();
}

class _RemoteViewState extends State<RemoteView> {
  late RemoteController _controller;
  bool _automatic = false;
  bool _waterPump = false;
  bool _mixer = false;
  int? _autoCheck = 0;

  @override
  void initState() {
    super.initState();
    _controller = RemoteController(
      onSettingsChanged: (automatic, waterPump, mixer, autoCheck) {
        setState(() {
          _automatic = automatic;
          _waterPump = waterPump;
          _mixer = mixer;
          _autoCheck = autoCheck;
        });
      },
    );
    _controller.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stroke,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(
                height: 55.0,
              ),
              const CardWidget(),
              const SizedBox(height: 15.0),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Settings :',
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: AppColors.white),
                child: Column(
                  children: [
                    TextSwitchRow(
                      leading: Assets.icons.boxWire.svg(
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primary, BlendMode.srcIn),
                      ),
                      title: "Automatic",
                      value: _automatic,
                      onChanged: (value) async {
                        _controller.setAutomatic(value);
                        await _controller.updateSettings();
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
                      value: _waterPump,
                      onChanged: (value) async {
                        _controller.setWaterPump(value);
                        await _controller.updateSettings();
                      },
                    ),
                    const Divider(height: 0.1, thickness: 0.5),
                    TextSwitchRow(
                      leading: Assets.icons.fanSvgrepoCom.svg(
                        width: 25,
                        height: 25,
                      ),
                      title: "Mixer",
                      value: _mixer,
                      onChanged: (value) async {
                        _controller.setMixer(value);
                        await _controller.updateSettings();
                      },
                    ),
                  ],
                ),
              ),
              if (_automatic == true) const SizedBox(height: 15.0),
              if (_automatic == true)
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Checking Sensor :',
                    style: TextStyle(
                      color: AppColors.gray,
                    ),
                  ),
                ),
              if (_automatic == true)
                Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: ScrollController(),
                      child: Row(
                        children: List.generate(
                          5,
                          (index) {
                            bool selected = index ==
                                (_autoCheck != 0 ? _autoCheck! - 1 : 0);

                            return GestureDetector(
                              onTap: () async {
                                _controller.setAutoCheck(index + 1);
                                await _controller.updateSettings();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.gray,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}x/Jam",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 15.0),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Kalibrasi :',
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: AppColors.white),
                child: Row(
                  children: [
                    ButtonEx(
                      title: "Sensor TDS",
                      icon: Assets.icons.tds,
                      onTap: () {
                        showCalibrationDialog(context , "tds");
                        print("Sensor TDS ditekan");
                      },
                    ),
                    ButtonEx(
                      title: "Sensor PH",
                      icon: Assets.icons.ph,
                      onTap: () {
                       showCalibrationDialog(context,'ph');
                        print("Sensor PH ditekan");
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Larutan :',
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: AppColors.white),
                child: Column(
                  children: [
                    TextInputRow(
                      title: 'pH Down',
                      subtitle: 'tambahkan larutan pH Down',
                      onChanged: (value) {
                        _controller.updateFirestoreField(
                            'phDown', double.tryParse(value) ?? 0.0);
                      },
                    ),
                    const Divider(height: 0.1, thickness: 0.5),
                    TextInputRow(
                      title: 'pH Up',
                      subtitle: 'tambahkan larutan pH Up',
                      onChanged: (value) {
                        _controller.updateFirestoreField(
                            'phUp', double.tryParse(value) ?? 0.0);
                      },
                    ),
                    const Divider(height: 0.1, thickness: 0.5),
                    TextInputRow(
                      title: 'Nutrisi',
                      subtitle: 'tambahkan larutan Nutrisi',
                      onChanged: (value) {
                        _controller.updateFirestoreField(
                            'nutrisi', double.tryParse(value) ?? 0.0);
                      },
                    ),
                    const Divider(height: 0.1, thickness: 0.5),
                    TextInputRow(
                      title: 'Water',
                      subtitle: 'tambahkan air',
                      onChanged: (value) {
                        _controller.updateFirestoreField(
                            'water', double.tryParse(value) ?? 0);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
