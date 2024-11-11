import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';

// import 'package:graphic/graphic.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defauld,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Assets.icons.messageCircle.svg(
                width: 25,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              )),
          IconButton(
              onPressed: () {},
              icon: Assets.icons.moreCirle.svg(
                width: 25,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              )),
        ],
      ),
      body: const  Column(
        children: [
         
        ],
      ),
    );
  }
}
