import 'package:flutter/material.dart';

ElevatedButton iconButton(Color color, String image, {required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Image.asset(
      '../assets/images/$image.png',
      width: 30,
      height: 30,
    ),
  );
}
