import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/presentations/notif/view/notif_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> sensorDataPh = [];

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  // Fungsi untuk mengambil data dari Firebase
  void _fetchSensorData() {
    print('Daa');
    _firestore.collection('phData').snapshots().listen((snapshot) {
      setState(() {
        sensorDataPh = snapshot.docs.map((doc) {
          final data = doc.data();
          print('-------createdAt: ${data['createdAt']}');
          print('-------phLevel: ${data['phLevel']}');

          return {
            'createdAt': DateFormat('EEE HH:mm:ss').format(
              (data['createdAt'] as Timestamp).toDate(),
            ), // Format waktu
            'value': data['phLevel'] as num, // Nilai pH
          };
        }).toList();

        // Cetak sensorDataPh untuk memastikan isinya
        print("sensorDataPh setelah setState: $sensorDataPh");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defauld,
      appBar: AppBar(
        backgroundColor: AppColors.defauld,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const NotifView());
            },
            icon: Assets.icons.bell.svg(
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Data pH',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (sensorDataPh.isEmpty)
                const Text(
                  "Data pH masih kosong",
                  style: TextStyle(
                    color: AppColors.stroke,
                    fontSize: 16.0,
                  ),
                ),
              if (sensorDataPh.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: Chart(
                    data: sensorDataPh, // Menggunakan data dari Firebase
                    variables: {
                      'createdAt': Variable(
                        accessor: (Map datum) => datum['createdAt'] as String,
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
