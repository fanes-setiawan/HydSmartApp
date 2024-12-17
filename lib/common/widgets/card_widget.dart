import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.bottomCenter,
          colors: <Color>[
          AppColors.primary,
          AppColors.primary.withOpacity(0.1),
        ]),
        borderRadius: BorderRadius.circular(18),
        boxShadow:   [
        BoxShadow(
        color: AppColors.gray.withOpacity(0.1),
        blurRadius:3,
        offset: const Offset(1, 3),
        ),
        ],
      ),
      child: ListTile(
        leading: Assets.icons.checkStampFilled.svg(
          width: 24,
          height: 24,
          colorFilter:
              const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        ),
        title: const  Text("Control"),
        subtitle: const  Text("lakukan perintah sesuai kebutuhan..."),
      ),
    );
  }
}
