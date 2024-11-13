import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/presentations/widgets/card_widget.dart';
import 'package:hyd_smart_app/presentations/widgets/text_input_button.dart';
import 'package:hyd_smart_app/presentations/widgets/text_switch_button.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = RemoteController(
      onSettingsChanged: (automatic, waterPump, mixer) {
        setState(() {
          _automatic = automatic;
          _waterPump = waterPump;
          _mixer = mixer;
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
              const SizedBox(
                height: 10.0,
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
              const SizedBox(height: 15.0),
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
