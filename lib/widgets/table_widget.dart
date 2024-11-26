import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

Widget tableCellHeader(String text) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.bold, color: cream),
    ),
  );
}

Widget tableCell(String text, TextAlign align) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      text,
      textAlign: align,
      style: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );
}
