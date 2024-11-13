import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';
import 'package:hyd_smart_app/common/message/showTopSnackBar.dart';

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
    return GestureDetector(
      onTap: () async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0 ml',
                          hintStyle: TextStyle(
                              color: AppColors.black.withOpacity(0.6)),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2.0),
                          ),
                        ),
                      
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stroke,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(color: AppColors.gray)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    final value = _controller.text;
                    if (value.isNotEmpty && double.tryParse(value) != null) {
                      try {
                        widget.onChanged(value);
                        _controller.text = '';
                        print("Firebase updated with value: $value");
                        showTopSnackBar(
                          context: context,
                          title: 'Hydroponik Smart',
                          message:
                              '${widget.title} $value ml berhasil ditambahkan',
                        );
                      } catch (e) {
                        print("Failed to update Firebase: $e");
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add",
                      style: TextStyle(color: AppColors.white)),
                ),
              ],
            );
          },
        );
      },
      child: ListTile(
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
          style: TextStyle(
            fontSize: 11,
            color: AppColors.gray.withOpacity(0.5),
          ),
        ),
        trailing: Assets.icons.chevronRight.svg(
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(AppColors.gray, BlendMode.srcIn),
        ),
      ),
    );
  }
}
