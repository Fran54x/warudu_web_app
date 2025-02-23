import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warudu_web_app/colors.dart';
import '../constants.dart';

class AddIngredientScreen extends StatefulWidget {
  final Map<String, dynamic>? ingredient;
  final bool isEditing;

  AddIngredientScreen({this.ingredient, this.isEditing = false});

  @override
  State<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.ingredient != null) {
      _nombreController.text = widget.ingredient!['nombre'];
      _categoriaController.text = widget.ingredient!['categoria'];
    } else {
      _clearForm();
    }
  }

  void _clearForm() {
    _nombreController.clear();
    _categoriaController.clear();
  }

  Future<void> saveIngredient() async {
    final url = Uri.parse(widget.isEditing
        ? '$baseUrl/editar_ingrediente'
        : '$baseUrl/agregar_ingrediente');
    final body = jsonEncode({
      'id': widget.ingredient?['id'], // Incluimos el id si es una edición
      'nombre': _nombreController.text,
      'categoria': _categoriaController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.isEditing
                  ? 'Ingrediente editado exitosamente'
                  : 'Ingrediente agregado exitosamente')),
        );
        if (!widget.isEditing) {
          _clearForm(); // Limpiar el formulario si se añadió un nuevo ingrediente
        }
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            // Columna izquierda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing ? "Editar Ingrediente" : "Ingredientes",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Campos de entrada
                  dataInput("Nombre", 25, _nombreController, singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Categoría", 25, _categoriaController,
                      singleLine: true),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(width: 20),
            // Columna derecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveIngredient();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: coral,
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.isEditing ? 'Editar' : 'Agregar',
                      style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: cream),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget personalizado para campos de entrada
  Column dataInput(
      String label, double borderRadius, TextEditingController controller,
      {bool singleLine = false, bool multiLine = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: coral,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: multiLine ? 6 : 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: cream,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: coral, width: 4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: coral, width: 4),
            ),
          ),
        ),
      ],
    );
  }
}
