import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warudu_web_app/colors.dart';
import '../constants.dart';

class AddDishScreen extends StatefulWidget {
  final Map<String, dynamic>? dish;
  final bool isEditing;

  AddDishScreen({this.dish, this.isEditing = false});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  final TextEditingController _preparacionController = TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();
  List<Map<String, dynamic>> availableIngredients = [];
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> filteredIngredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.dish != null) {
      fetchDishDetails(int.parse(widget.dish!['id']));
    } else {
      _clearForm();
    }
    fetchIngredients();
    _ingredientSearchController.addListener(_filterIngredients);
  }

  void _clearForm() {
    _nombreController.clear();
    _imagenController.clear();
    _tiempoController.clear();
    _preparacionController.clear();
    _ingredientSearchController.clear();
    selectedIngredients.clear();
    filteredIngredients = [];
  }

  Future<void> fetchIngredients() async {
    final url = Uri.parse('$baseUrl/ingredientes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          availableIngredients = data.map((ingredient) {
            return {
              'id': ingredient['id'],
              'nombre': ingredient['nombre'],
            };
          }).toList();
          filteredIngredients = availableIngredients;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchDishDetails(int platilloId) async {
    final url = Uri.parse('$baseUrl/platillos/$platilloId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _nombreController.text = data['nombre'];
          _imagenController.text = data['imagen'];
          _tiempoController.text = data['tiempo'].toString();
          _preparacionController.text = data['preparacion'];
          selectedIngredients =
              List<Map<String, dynamic>>.from(data['ingredientes']);
          selectedIngredients.forEach((selectedIngredient) {
            availableIngredients.removeWhere(
                (ingredient) => ingredient['id'] == selectedIngredient['id']);
          });
          filteredIngredients = availableIngredients;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveDish() async {
    final url = Uri.parse(widget.isEditing
        ? '$baseUrl/editar_platillo'
        : '$baseUrl/agregar_platillo');
    final body = jsonEncode({
      'id': widget.dish?['id'], // Incluimos el id si es una edición
      'nombre': _nombreController.text,
      'imagen': _imagenController.text,
      'tiempo': _tiempoController.text,
      'ingredientes':
          selectedIngredients.map((ingredient) => ingredient['id']).toList(),
      'preparacion': _preparacionController.text,
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
                  ? 'Platillo editado exitosamente'
                  : 'Platillo agregado exitosamente')),
        );
        if (!widget.isEditing) {
          _clearForm(); // Limpiar el formulario si se añadió un nuevo platillo
        }
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addIngredient(Map<String, dynamic> ingredient) {
    setState(() {
      selectedIngredients.add(ingredient);
      availableIngredients.removeWhere((i) => i['id'] == ingredient['id']);
      _filterIngredients(); // Actualizar lista filtrada
      _ingredientSearchController.clear();
    });
  }

  void _removeIngredient(Map<String, dynamic> ingredient) {
    setState(() {
      availableIngredients.add(ingredient);
      selectedIngredients.removeWhere((i) => i['id'] == ingredient['id']);
      _filterIngredients(); // Actualizar lista filtrada
    });
  }

  void _filterIngredients() {
    setState(() {
      final query = _ingredientSearchController.text.toLowerCase();
      filteredIngredients = availableIngredients.where((ingredient) {
        return ingredient['nombre'].toLowerCase().contains(query);
      }).toList();
    });
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
                        widget.isEditing ? "Editar Platillo" : "Platillos",
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
                  dataInput("Imagen", 25, _imagenController, singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Tiempo Estimado", 25, _tiempoController,
                      singleLine: true),
                  SizedBox(height: 10),
                  dataInput("Preparación", 25, _preparacionController,
                      multiLine: true),
                ],
              ),
            ),
            SizedBox(width: 20),
            // Columna derecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de ingredientes
                  Text(
                    "Ingredientes",
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: coral,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedIngredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = selectedIngredients[index];
                        return ListTile(
                          title: Text(ingredient['nombre']),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle, color: red),
                            onPressed: () {
                              _removeIngredient(ingredient);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _ingredientSearchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar Ingrediente',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: coral),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredIngredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = filteredIngredients[index];
                        return ListTile(
                          title: Text(ingredient['nombre']),
                          trailing: IconButton(
                            icon: Icon(Icons.add_circle, color: green),
                            onPressed: () {
                              _addIngredient(ingredient);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      saveDish();
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
