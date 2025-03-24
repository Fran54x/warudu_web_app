import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final double size;

  const TitleWidget({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: green,
        ),
      ),
    );
  }
}
