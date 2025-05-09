import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/widgets/text_button_widget.dart';
import 'package:warudu_web_app/widgets/validate_input_widget.dart';
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
  final TextEditingController _imagenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.ingredient != null) {
      _nombreController.text = widget.ingredient!['nombre'];
      _imagenController.text = widget.ingredient!['imagen'];
    } else {
      _clearForm();
    }
  }

  void _clearForm() {
    _nombreController.clear();
    _imagenController.clear();
  }

  Future<void> saveIngredient() async {
    final url = Uri.parse(widget.isEditing
        ? '$baseUrl/editar_ingrediente'
        : '$baseUrl/agregar_ingrediente');
    final body = jsonEncode({
      'id': widget.ingredient?['id'], // Incluimos el id si es una edición
      'nombre': _nombreController.text,
      'imagen': _imagenController.text,
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
         _clearForm(); // Limpiar el formulario si se añadió un nuevo ingrediente
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditing ? "Editar Ingrediente" : "Agregar Ingrediente",
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              SizedBox(height: 30),
              // Campos de entrada
              ValidatedInputField(
                label: "Nombre del Ingrediente",
                controller: _nombreController,
              ),
              SizedBox(height: 10),
              ValidatedInputField(
                label: "Imagen",
                controller: _imagenController,
              ),
              SizedBox(height: 10),
              TextButtonWidget(
                onAddPressed: saveIngredient,
                wHorizontal: 70,
                wVertical: 20,
                fontSize: 30,
                text: widget.isEditing ? 'Editar' : 'Agregar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _imagenController.dispose();
    super.dispose();
  }
}
