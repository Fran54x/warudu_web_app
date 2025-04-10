import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/widgets/text_button_widget.dart';
import 'package:warudu_web_app/widgets/validate_input_widget.dart';
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
  //final TextEditingController _valoracionController = TextEditingController();
  //final TextEditingController _dificultadController = TextEditingController();
  final TextEditingController _linkRecetaController = TextEditingController();
  final TextEditingController _tipoPlatilloController = TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();
  List<Map<String, dynamic>> availableIngredients = [];
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> filteredIngredients = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

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
    _scrollController.addListener(_loadMore); // Agregar el listener
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nombreController.clear();
    _imagenController.clear();
    _tiempoController.clear();
    _preparacionController.clear();
    //_valoracionController.clear();
    //_dificultadController.clear();
    _linkRecetaController.clear();
    _tipoPlatilloController.clear();
    _ingredientSearchController.clear();
    selectedIngredients.clear();
    filteredIngredients = [];
  }

  Future<void> fetchIngredients({int page = 1, String? searchQuery}) async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    final url = Uri.parse(
        '$baseUrl/ingredientes_ordenados_alfabeticamente?page=$page&limit=10${searchQuery != null ? '&query=$searchQuery' : ''}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ingredientsData = data['data'];

        setState(() {
          if (page == 1) {
            availableIngredients = ingredientsData.map((ingredient) {
              return {
                'id': ingredient['id'],
                'nombre': ingredient['nombre'],
              };
            }).toList();
          } else {
            availableIngredients.addAll(ingredientsData.map((ingredient) {
              return {
                'id': ingredient['id'],
                'nombre': ingredient['nombre'],
              };
            }).toList());
          }

          filteredIngredients = availableIngredients;
          _hasMore = data['pagination']['totalPages'] > page;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _currentPage++;
      fetchIngredients(
          page: _currentPage,
          searchQuery: _ingredientSearchController.text.trim().isEmpty
              ? null
              : _ingredientSearchController.text.trim());
    }
  }

  Widget _buildLoader() {
    return Center(
      child: _isLoadingMore
          ? CircularProgressIndicator(color: green)
          : Container(),
    );
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
          //_valoracionController.text = data['valoracion']; // string
          //_dificultadController.text = data['dificultad'].toString(); // 1 - 10
          _linkRecetaController.text = data['link_receta'];
          _tipoPlatilloController.text = data['tipo'];
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
      'preparacion': _preparacionController.text,
      //'valoracion': "Fácil",
      //'dificultad': 8,
      'link_receta': _linkRecetaController.text,
      'tipo': _tipoPlatilloController.text,
      'ingredientes':
          selectedIngredients.map((ingredient) => ingredient['id']).toList(),
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
    final searchText = _ingredientSearchController.text.trim();
    if (searchText.isEmpty) {
      setState(() {
        filteredIngredients = availableIngredients;
      });
      // Cargar primera página sin filtro
      _currentPage = 1;
      fetchIngredients(page: 1);
      return;
    }

    // Cargar resultados filtrados desde el API
    _currentPage = 1;
    fetchIngredients(page: 1, searchQuery: searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditing ? "Editar Platillo" : "Agregar Platillo",
                style: GoogleFonts.inter(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              SizedBox(height: 20),
              ValidatedInputField(
                label: "Nombre del Platillo",
                controller: _nombreController,
              ),
              ValidatedInputField(
                label: "Imagen",
                controller: _imagenController,
              ),
              ValidatedInputField(
                label: "Tiempo Estimado",
                controller: _tiempoController,
                isNumeric: true,
              ),
              ValidatedInputField(
                label: "Preparación",
                controller: _preparacionController,
                isMultiline: true,
              ),
              ValidatedInputField(
                label: "Link de Receta",
                controller: _linkRecetaController,
              ),
              ValidatedInputField(
                label: "Tipo de Platillo",
                controller: _tipoPlatilloController,
              ),
              //dataInput("Valoración", 25, _valoracionController),
              //dataInput("Dificultad (1-10)", 25, _dificultadController),
              SizedBox(height: 20),
              Text(
                "Ingredientes",
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: coral,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250, // Altura fija para que no colapse
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: selectedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = selectedIngredients[index];
                      return ListTile(
                        title: Text(ingredient['nombre']),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: red),
                          onPressed: () {
                            _removeIngredient(
                                ingredient); // Eliminar el ingrediente
                          },
                        ),
                      );
                    },
                  ),
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
              SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: filteredIngredients.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredIngredients.length) {
                        return _buildLoader(); // Mostrar indicador de carga
                      }
                      final ingredient = filteredIngredients[index];
                      return ListTile(
                        title: Text(ingredient['nombre']),
                        trailing: IconButton(
                          icon: Icon(Icons.add_circle, color: green),
                          onPressed: () {
                            _addIngredient(ingredient); // Añadir el ingrediente
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButtonWidget(
                onAddPressed: saveDish,
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
}
