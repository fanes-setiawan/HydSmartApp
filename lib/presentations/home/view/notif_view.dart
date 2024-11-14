import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';

class NotifView extends StatefulWidget {
  const NotifView({super.key});

  @override
  State<NotifView> createState() => _NotifViewState();
}

class _NotifViewState extends State<NotifView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defauld,
      appBar: AppBar(
        backgroundColor: AppColors.defauld,
         title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.gray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
