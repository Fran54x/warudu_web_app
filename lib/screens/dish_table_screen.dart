import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';
import '../components/icon_button.dart';
import '../widgets/table_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class DishTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed; // Callback para agregar un nuevo platillo
  final Function(Map<String, dynamic>)
      onEditPressed; // Callback para editar un platillo

  DishTableScreen({required this.onAddPressed, required this.onEditPressed});

  @override
  _DishTableScreenState createState() => _DishTableScreenState();
}

class _DishTableScreenState extends State<DishTableScreen> {
  List<Map<String, dynamic>> dishes = [];
  List<Map<String, dynamic>> filteredDishes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDishes();
    _searchController.addListener(_filterDishes);
  }

  Future<void> fetchDishes() async {
    final url = Uri.parse('$baseUrl/platillos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          dishes = data.map((dish) {
            return {
              'id': dish['id'].toString(),
              'nombre': dish['nombre'],
              'imagen': dish['imagen'],
              'descripcion': dish['descripcion'],
              'preparacion': dish['preparacion'],
              'tiempo': dish['tiempo'].toString(),
              'ingredientes': dish['ingredientes'],
            };
          }).toList();
          filteredDishes = dishes;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterDishes() {
    setState(() {
      if (_isNumeric(_searchController.text)) {
        filteredDishes = dishes
            .where((dish) => dish['id'].contains(_searchController.text))
            .toList();
      } else {
        filteredDishes = dishes
            .where((dish) => dish['nombre']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> deleteDish(Map<String, dynamic> dish) async {
    final url = Uri.parse('$baseUrl/eliminar_platillo/${dish['id']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          dishes.removeWhere((d) => d['id'] == dish['id']);
          filteredDishes = dishes;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Platillo eliminado exitosamente')),
        );
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  controller: _searchController,
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
                onPressed: widget
                    .onAddPressed, // Acción para agregar un nuevo platillo
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
                  // Filas de la tabla filtrada
                  for (var dish in filteredDishes)
                    TableRow(
                      decoration: BoxDecoration(color: cream),
                      children: [
                        tableCell(dish['id']!, TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: tableCell(dish['nombre']!, TextAlign.start),
                        ),
                        tableCell(dish['tiempo']! + " min", TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconButton(orange, "edit",
                                  onPressed: () => widget.onEditPressed(dish)),
                              SizedBox(width: 10),
                              iconButton(red, "delete",
                                  onPressed: () => deleteDish(dish)),
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
