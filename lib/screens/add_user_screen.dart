import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/widgets/validate_input_widget.dart';
import '../constants.dart';

class AddUserScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  final bool isEditing;

  AddUserScreen({this.user, this.isEditing = false});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedOption = 0;
  bool _isPasswordVisible = false; // Visibilidad de la contraseña

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.user != null) {
      _nombreController.text = widget.user!['nombre'];
      _imagenController.text = widget.user!['imagen'];
      _correoController.text = widget.user!['correo'];
      _passwordController.text = widget.user!['password'];
      _selectedOption = widget.user!['tipo_usuario'];
    } else {
      _clearForm();
    }
  }

  void _clearForm() {
    _nombreController.clear();
    _imagenController.clear();
    _correoController.clear();
    _passwordController.clear();
    _selectedOption = 0;
  }

  Future<void> saveUser() async {
    final url = Uri.parse(widget.isEditing
        ? '$baseUrl/editar_usuario'
        : '$baseUrl/agregar_usuario');
    final body = jsonEncode({
      'id': widget.user?['id'], // Incluimos el id si es una edición
      'nombre': _nombreController.text,
      'imagen': _imagenController.text,
      'correo': _correoController.text,
      'password': _passwordController.text,
      if (_selectedOption != 0) 'tipo_usuario': _selectedOption,
    });

    // Validar correo electrónico
    if (!_isValidEmail(_correoController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, ingrese un correo electrónico válido')),
      );
      return;
    }

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
                  ? 'Usuario editado exitosamente'
                  : 'Usuario agregado exitosamente')),
        );
        if (!widget.isEditing) {
          _clearForm(); // Limpiar el formulario si se añadió un nuevo usuario
        }
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
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
                        widget.isEditing ? "Editar Usuario" : "Usuarios",
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
                  ValidatedInputField(
                    label: "Nombre del Usuario",
                    controller: _nombreController,
                  ),
                  SizedBox(height: 10),
                  ValidatedInputField(
                    label: "Imagen",
                    controller: _imagenController,
                  ),
                  SizedBox(height: 10),
                  ValidatedInputField(
                    label: "Correo",
                    controller: _correoController,
                  ),
                  SizedBox(height: 10),
                  ValidatedInputField(
                    label: "Contraseña",
                    controller: _passwordController,
                    isPassword: true,
                  ),
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
                  SizedBox(height: 60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Tipo de Usuario",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: coral,
                          ),
                        ),
                      ),
                      createRadioListTile(0, 'Normal'),
                      createRadioListTile(1, 'Premium'),
                      createRadioListTile(2, 'Administrador'),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      saveUser();
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

  Widget createRadioListTile(int value, String label) {
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.start,
        style: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: coral,
        ),
      ),
      leading: Radio<int>(
        value: value,
        groupValue: _selectedOption,
        fillColor: WidgetStateProperty.all(coral),
        onChanged: (int? newValue) {
          setState(() {
            if (newValue != null) {
              _selectedOption = newValue;
            }
          });
        },
      ),
    );
  }
}
