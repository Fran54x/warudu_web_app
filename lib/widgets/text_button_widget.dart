import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';

class TextButtonWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final double wHorizontal; // Padding horizontal
  final double wVertical; // Padding vertical
  final double fontSize;
  final String text;

  const TextButtonWidget({
    Key? key,
    required this.onAddPressed,
    required this.wHorizontal,
    required this.wVertical,
    required this.fontSize,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onAddPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: coral,
        padding: EdgeInsets.symmetric(
          horizontal: wHorizontal, // Padding horizontal
          vertical: wVertical, // Padding vertical
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: cream,
        ),
      ),
    );
  }
}
