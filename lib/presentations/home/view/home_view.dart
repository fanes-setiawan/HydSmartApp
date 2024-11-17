import 'dart:ui';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/common/message/firebase.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/presentations/home/view/notif_view.dart';
import 'package:hyd_smart_app/presentations/home/view/schedule_view.dart';
import 'package:hyd_smart_app/presentations/home/controller/home_controller.dart';
// ignore_for_file: deprecated_member_use_from_same_package

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(context: context, setState: setState);
    NotificationHandler.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stroke,
      appBar: AppBar(
        backgroundColor: AppColors.stroke,
        actions: [
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: DBHelper().getUnreadNotifications(),
            builder: (context, snapshot) {
              final unreadCount =
                  snapshot.data?.length ?? 0; // Default ke 0 jika null
              return GestureDetector(
                onTap: () {
                  Get.to(const NotifView()); // Buka halaman notifikasi
                },
                child: Badge(
                  isLabelVisible: unreadCount != 0,
                  label: (unreadCount != 0)
                      ? Text(
                          "$unreadCount",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : null,
                  child: Assets.icons.bell.svg(
                    width: 25,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            onPressed: () {
              Get.to(ScheduleView());
            },
            icon: Assets.icons.workScheduleIcon.svg(
              width: 25,
              colorFilter: const ColorFilter.mode(
                AppColors.gray,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Data pH',
                      style: TextStyle(
                        color: AppColors.gray,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _controller.getSensorDataStream(),
                      builder: (context, snapshot) {
                        dlg('Snapshot updated with ${snapshot.data} documents');
                        dlg('StreamBuilder rebuild triggered');
                        dlg('Connection state: ${snapshot.connectionState}');
                        dlg('Has data: ${snapshot.hasData}');
                        dlg('Error: ${snapshot.error}');
                        dlg('Data: ${snapshot.data}');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text('Getting sensor data stream...'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text(
                            "Data pH masih kosong",
                            style: TextStyle(
                              color: AppColors.stroke,
                              fontSize: 16.0,
                            ),
                          );
                        }

                        // final sensorDataPh = snapshot.data!;

                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Chart(
                            data: snapshot.data!,
                            variables: {
                              'createdAt': Variable(
                                accessor: (Map datum) =>
                                    datum['createdAt'] as String,
                                scale: OrdinalScale(inflate: true),
                              ),
                              'value': Variable(
                                accessor: (Map datum) => datum['value'] as num,
                                scale: LinearScale(
                                  max: 14,
                                  min: 0,
                                  tickCount: 7,
                                  formatter: (v) => '${v.toInt()} pH',
                                ),
                              ),
                            },
                            marks: [
                              LineMark(
                                position: Varset('createdAt') * Varset('value'),
                                color: ColorEncode(
                                  variable: 'value',
                                  values: [AppColors.blue, AppColors.blue],
                                ),
                              ),
                              PointMark(
                                position: Varset('createdAt') * Varset('value'),
                              ),
                            ],
                            axes: [
                              Defaults.horizontalAxis,
                              Defaults.verticalAxis,
                            ],
                            selections: {
                              'tooltipMouse': PointSelection(on: {
                                GestureType.hover,
                              }, devices: {
                                PointerDeviceKind.mouse
                              }, variable: 'createdAt', dim: Dim.x),
                              'tooltipTouch': PointSelection(on: {
                                GestureType.scaleUpdate,
                                GestureType.tapDown,
                                GestureType.longPressMoveUpdate
                              }, devices: {
                                PointerDeviceKind.touch
                              }, variable: 'createdAt', dim: Dim.x),
                            },
                            tooltip: TooltipGuide(
                              followPointer: [true, true],
                              align: Alignment.topLeft,
                              variables: ['createdAt', 'value'],
                            ),
                            crosshair: CrosshairGuide(
                              followPointer: [false, true],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Data Nutrisi',
                      style: TextStyle(
                        color: AppColors.gray,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _controller.getNutrisiDataStream(),
                      builder: (context, snapshot) {
                        dlg('StreamBuilder Nutrisi triggered');
                        dlg('Connection state: ${snapshot.connectionState}');
                        dlg('Has data: ${snapshot.hasData}');
                        dlg('Error: ${snapshot.error}');
                        dlg('Nutrisi data: ${snapshot.data}');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text('Loading nutrisi data...'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text(
                            "Data nutrisi masih kosong",
                            style: TextStyle(
                              color: AppColors.stroke,
                              fontSize: 16.0,
                            ),
                          );
                        }

                        final nutrisiData = snapshot.data!;
                        dlg('Rendering Chart Nutrisi with data: $nutrisiData');

                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Chart(
                            data: nutrisiData,
                            variables: {
                              'createdAt': Variable(
                                accessor: (Map datum) =>
                                    datum['createdAt'] as String,
                                scale: OrdinalScale(inflate: true),
                              ),
                              'nutrisiLevel': Variable(
                                accessor: (Map datum) =>
                                    datum['nutrisiLevel'] as num,
                                scale: LinearScale(
                                  max: 1400,
                                  min: 0,
                                  tickCount: 5,
                                  formatter: (v) => '${v.toInt()} ppm',
                                ),
                              ),
                            },
                            marks: [
                              IntervalMark(
                                position: Varset('createdAt') *
                                    Varset('nutrisiLevel'),
                                color: ColorEncode(
                                  variable: 'nutrisiLevel',
                                  values: [AppColors.primary, AppColors.black],
                                ),
                                size: SizeEncode(value: 10), // Lebar bar
                              ),
                            ],
                            axes: [
                              Defaults.horizontalAxis,
                              Defaults.verticalAxis,
                            ],
                            selections: {
                              'tooltipMouse': PointSelection(on: {
                                GestureType.hover,
                              }, devices: {
                                PointerDeviceKind.mouse
                              }, variable: 'createdAt', dim: Dim.x),
                              'tooltipTouch': PointSelection(on: {
                                GestureType.scaleUpdate,
                                GestureType.tapDown,
                                GestureType.longPressMoveUpdate
                              }, devices: {
                                PointerDeviceKind.touch
                              }, variable: 'createdAt', dim: Dim.x),
                            },
                            tooltip: TooltipGuide(
                              followPointer: [true, true],
                              align: Alignment.topLeft,
                              variables: ['createdAt', 'nutrisiLevel'],
                            ),
                            crosshair: CrosshairGuide(
                              followPointer: [false, true],
                            ),
                          ),
                        );
                      },
                    )
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
