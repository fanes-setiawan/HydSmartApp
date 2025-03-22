import 'dart:ui';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/common/message/firebase.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:hyd_smart_app/core/components/color_indicator.dart';
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
            key: UniqueKey(),
            stream: DBHelper().getUnreadNotifications(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data?.length ?? 0; //
              return GestureDetector(
                onTap: () {
                  Get.to(const NotifView());
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
              StreamBuilder<double>(
                stream: _controller.lastPhStream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: colorIndicator(ph: _controller.lastPh.toString()),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text("${_controller.lastPh} pH"),
                      ],
                    ),
                  );
                }
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
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Chart(
                            key: UniqueKey(),
                            data: snapshot.data!,
                            variables: {
                              'createdAt': Variable(
                                accessor: (Map datum) =>
                                    datum['createdAt'] as String,
                                scale: OrdinalScale(inflate: true),
                              ),
                              'phLevel': Variable(
                                accessor: (Map datum) =>
                                    datum['phLevel'] as num,
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
                                position:
                                    Varset('createdAt') * Varset('phLevel'),
                                color: ColorEncode(
                                  variable: 'phLevel',
                                  values: [AppColors.blue, AppColors.blue],
                                ),
                              ),
                              PointMark(
                                position:
                                    Varset('createdAt') * Varset('phLevel'),
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
                              variables: ['createdAt', 'phLevel'],
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
              StreamBuilder<double>(
                stream: _controller.lastTdsStream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: colorIndicator(tds: _controller.lastTds.toString()),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text("${_controller.lastTds} ppm"),
                      ],
                    ),
                  );
                }
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
                            key: UniqueKey(),
                            data: nutrisiData,
                            variables: {
                              'createdAt': Variable(
                                accessor: (Map datum) =>
                                    datum['createdAt'] as String,
                                scale: OrdinalScale(inflate: true),
                              ),
                              'tdsLevel': Variable(
                                accessor: (Map datum) =>
                                    datum['tdsLevel'] as num,
                                scale: LinearScale(
                                  max: nutrisiData[0]['tdsLevel']< 1000 ?1000 :1400,
                                  min: 0,
                                  tickCount: 5,
                                  formatter: (v) => '${v.toInt()} ppm',
                                ),
                              ),
                            },
                            marks: [
                              IntervalMark(
                                position:
                                    Varset('createdAt') * Varset('tdsLevel'),
                                color: ColorEncode(
                                  variable: 'tdsLevel',
                                  values: [AppColors.red, AppColors.primary , AppColors.black],
                                ),
                                size: SizeEncode(value: 12),
                                
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
