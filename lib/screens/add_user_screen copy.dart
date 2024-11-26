import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';

class AddUserScreen extends StatefulWidget {
  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String _selectedOption = 'Normal';

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
                        "Usuarios",
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
                  dataInput("Nombre", 25, singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Imagen", 25, singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Correo", 25, singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Contraseña", 25, singleLine: true),
                  SizedBox(height: 10),
                  // Añade más widgets aquí para la columna izquierda
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
                      createRadioListTile('Normal'),
                      createRadioListTile('Premium'),
                      createRadioListTile('Administrador'),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para agregar un nuevo platillo
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
                      'Agregar',
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
  Column dataInput(String label, double borderRadius,
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

  Widget createRadioListTile(String value) {
    return ListTile(
      title: Text(
        value,
        textAlign: TextAlign.start,
        style: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: coral,
        ),
      ),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedOption,
        fillColor: WidgetStateProperty.all(coral),
        onChanged: (String? newValue) {
          setState(() {
            _selectedOption = newValue!;
          });
        },
      ),
    );
  }
}
