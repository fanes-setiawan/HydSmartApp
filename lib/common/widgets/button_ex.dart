import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyd_smart_app/core/assets/assets.gen.dart';


class ButtonEx extends StatelessWidget {
  final String title;
  final AssetGenImage icon;
  final VoidCallback onTap;

  const ButtonEx({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon.image(
                  width: 25,
                  height: 25,
                ),
                const SizedBox(width: 5.0),
                Text(
                  title,
                  style: GoogleFonts.aDLaMDisplay(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
