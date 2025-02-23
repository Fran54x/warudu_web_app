import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';
import '../components/icon_button.dart';
import '../widgets/table_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class IngredientTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed; // Callback para agregar un nuevo ingrediente
  final Function(Map<String, dynamic>) onEditPressed; // Callback para editar un ingrediente

  IngredientTableScreen({required this.onAddPressed, required this.onEditPressed});

  @override
  _IngredientTableScreenState createState() => _IngredientTableScreenState();
}

class _IngredientTableScreenState extends State<IngredientTableScreen> {
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> filteredIngredients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchIngredients();
    _searchController.addListener(_filterIngredients);
  }

  Future<void> fetchIngredients() async {
    final url = Uri.parse('$baseUrl/ingredientes');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          ingredients = data.map((ingredient) {
            return {
              'id': ingredient['id'].toString(),
              'nombre': ingredient['nombre'],
              'categoria': ingredient['categoria'],
            };
          }).toList();
          filteredIngredients = ingredients;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteIngredient(Map<String, dynamic> ingredient) async {
    final url = Uri.parse('$baseUrl/eliminar_ingrediente/${ingredient['id']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          ingredients.removeWhere((i) => i['id'] == ingredient['id']);
          filteredIngredients = ingredients;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingrediente eliminado exitosamente')),
        );
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterIngredients() {
    setState(() {
      if (_isNumeric(_searchController.text)) {
        filteredIngredients = ingredients
            .where((ingredient) =>
                ingredient['id'].contains(_searchController.text))
            .toList();
      } else {
        filteredIngredients = ingredients
            .where((ingredient) => ingredient['nombre']
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
              "Ingredientes",
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
                onPressed: widget.onAddPressed, // Acción para agregar un nuevo ingrediente
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
          // Tabla de ingredientes con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: coral, width: 3),
                columnWidths: {
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(230),
                  3: FixedColumnWidth(140),
                },
                children: [
                  // Encabezados de la tabla
                  TableRow(
                    decoration: BoxDecoration(color: coral),
                    children: [
                      tableCellHeader('ID'),
                      tableCellHeader('Nombre Ingrediente'),
                      tableCellHeader('Categoria'),
                      tableCellHeader(''),
                    ],
                  ),
                  // Filas de la tabla filtrada
                  for (var ingredient in filteredIngredients)
                    TableRow(
                      decoration: BoxDecoration(color: cream),
                      children: [
                        tableCell(ingredient['id']!, TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child:
                              tableCell(ingredient['nombre']!, TextAlign.start),
                        ),
                        tableCell(ingredient['categoria']!, TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconButton(orange, "edit",
                                  onPressed: () =>
                                      widget.onEditPressed(ingredient)),
                              SizedBox(width: 10),
                              iconButton(red, "delete", onPressed: () => deleteIngredient(ingredient)),
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
