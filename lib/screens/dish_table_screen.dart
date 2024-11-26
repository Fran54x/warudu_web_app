import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';
import '../components/icon_button.dart';
import '../widgets/table_widget.dart';

class DishTableScreen extends StatelessWidget {
  final List<Map<String, String>> dishes = [
    {'id': '1', 'nombre': 'Mole Poblano', 'tiempo': '22 min'},
    {'id': '2', 'nombre': 'Frijoles Charros', 'tiempo': '15 min'},
    {'id': '3', 'nombre': 'Pollo con Arroz', 'tiempo': '32 min'},
    {'id': '4', 'nombre': 'Huevos Rancheros', 'tiempo': '16 min'},
    {'id': '5', 'nombre': 'Chilaquiles Rojos', 'tiempo': '26 min'},
    {'id': '6', 'nombre': 'Chile en Rajas', 'tiempo': '42 min'},
    {'id': '7', 'nombre': 'Tacos de Birria', 'tiempo': '20 min'},
  ];

  final VoidCallback onAddPressed; // Nuevo parámetro callback
  DishTableScreen({required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titulo
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 20),
            child: Text(
              "Platillos",
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                  fontSize: 42, fontWeight: FontWeight.bold, color: green),
            ),
          ),
          // Barra de búsqueda y botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search, color: green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 60),
              ElevatedButton(
                onPressed:
                    onAddPressed, // Acción para agregar un nuevo platillo
                style: ElevatedButton.styleFrom(
                  backgroundColor: coral,
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Agregar',
                  style: GoogleFonts.inter(
                      fontSize: 30, fontWeight: FontWeight.bold, color: cream),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Tabla de platillos con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: coral, width: 3),
                columnWidths: {
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(140),
                },
                children: [
                  // Encabezados de la tabla
                  TableRow(
                    decoration: BoxDecoration(color: coral),
                    children: [
                      tableCellHeader('ID'),
                      tableCellHeader('Nombre Platillo'),
                      tableCellHeader('Tiempo'),
                      tableCellHeader(''),
                    ],
                  ),
                  // Filas de la tabla
                  for (var dish in dishes)
                    TableRow(
                      decoration: BoxDecoration(color: cream),
                      children: [
                        tableCell(dish['id']!, TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: tableCell(dish['nombre']!, TextAlign.start),
                        ),
                        tableCell(dish['tiempo']!, TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconButton(orange, "edit"),
                              SizedBox(width: 10),
                              iconButton(red, "delete"),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
