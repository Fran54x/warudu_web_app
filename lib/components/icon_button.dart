import 'package:flutter/material.dart';

ElevatedButton iconButton(Color color, String image) {
  return ElevatedButton(
    onPressed: () {
      //acción
    },
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
