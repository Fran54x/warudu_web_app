import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)?
      onChanged; // Nuevo parámetro para manejar cambios en el texto

  const SearchBarWidget({
    Key? key,
    required this.controller,
    this.onChanged, // Añadimos el parámetro onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Buscar',
          prefixIcon: const Icon(Icons.search, color: Colors.green),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged, // Asignamos la función onChanged al TextField
      ),
    );
  }
}
