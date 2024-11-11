import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class TextSwitchRow extends StatefulWidget {
  final String title;
  final bool value;
  final Color? background;
  final Function(bool)? onChanged;
  final Widget? leading;

  TextSwitchRow({
    Key? key,
    required this.title,
    required this.value,
    this.background,
    this.onChanged,
    this.leading,
  }) : super(key: key);

  @override
  _TextSwitchRowState createState() => _TextSwitchRowState();
}

class _TextSwitchRowState extends State<TextSwitchRow> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading,
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.black,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: widget.value,
          activeColor: AppColors.stroke,
          activeTrackColor: AppColors.primary,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
