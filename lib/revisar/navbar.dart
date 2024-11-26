import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class Navbar extends StatelessWidget {
  final Function(int) onSelect; // Callback para cambiar de vista
  final List<String> entries = ['Platillos', 'Ingredientes', 'Usuarios'];

  Navbar({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Línea naranja en el borde izquierdo
        Container(
          width: 14,
          color: coral,
        ),
        // Drawer con el diseño original
        SizedBox(
          width: 290,
          child: Drawer(
            shape: RoundedRectangleBorder(),
            child: Container(
              color: green,
              child: Column(
                children: <Widget>[
                  // Logo y título de la app
                  Container(
                    color: green,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          '../assets/images/warudu_logo_crema.png',
                          width: 120,
                          height: 120,
                        ),
                        Text(
                          'Warudu',
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            color: cream,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 6,
                          width: 200,
                          color: coral,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: green,
                      child: ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            child: TextButton(
                              onPressed: () {
                                // Llamada a onSelect para cambiar la vista
                                onSelect(index);
                                Navigator.pop(context); // Cierra el Drawer
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                entries[index],
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: cream,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
