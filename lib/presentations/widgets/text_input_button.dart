import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class TextInputRow extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Function(String) onChanged;

  final Widget? leading;
  const TextInputRow({
    Key? key,
    required this.title,
    this.subtitle,
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  @override
  _TextInputRowState createState() => _TextInputRowState();
}

class _TextInputRowState extends State<TextInputRow> {
  final TextEditingController _controller = TextEditingController();

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
      subtitle: Text(
        widget.subtitle ?? '',
        style:  TextStyle(
          fontSize: 11,
          color: AppColors.gray.withOpacity(0.5),
        ),
      ),
      trailing: Assets.icons.chevronRight.svg(
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(AppColors.gray, BlendMode.srcIn),
      ),
    );

    // Container(
    //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(12.0),
    //     color: AppColors.stroke,
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         widget.title,
    //         style: const TextStyle(
    //           fontSize: 14,
    //           color: AppColors.black,
    //         ),
    //       ),
    //       Container(
    //         width: 70,
    //         height: 40,
    //         child: TextField(
    //           controller: _controller,
    //           keyboardType: TextInputType.number,
    //           textAlign: TextAlign.center,
    //           decoration: InputDecoration(
    //             hintText: '0 ml',
    //             hintStyle: TextStyle(color: AppColors.black.withOpacity(0.6)),
    //             isDense: true,
    //             contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8.0),
    //               borderSide: BorderSide(color: AppColors.primary, width: 1.0),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8.0),
    //               borderSide: BorderSide(color: AppColors.primary, width: 2.0),
    //             ),
    //           ),
    //           onChanged: (value) {
    //             widget.onChanged(value); // Panggil callback ketika nilai berubah
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
