import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/widgets/search_bar_widget.dart';
import 'package:warudu_web_app/widgets/text_button_widget.dart';
import 'package:warudu_web_app/widgets/title_widget.dart';
import '../colors.dart';
import '../components/icon_button.dart';
import '../widgets/table_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

const minWidth = 700.0;

class IngredientTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed; // Callback para agregar un nuevo ingrediente
  final Function(Map<String, dynamic>)
      onEditPressed; // Callback para editar un ingrediente

  IngredientTableScreen(
      {required this.onAddPressed, required this.onEditPressed});

  @override
  _IngredientTableScreenState createState() => _IngredientTableScreenState();
}

class _IngredientTableScreenState extends State<IngredientTableScreen> {
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> filteredIngredients = [];
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  int limit = 20;
  bool isLoading = false;
  bool hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchIngredients();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          filteredIngredients = ingredients;
        });
      } else {
        _filterIngredients();
      }
    });
    _scrollController.addListener(_loadMore);
  }

  Future<void> fetchIngredients() async {
    if (isLoading || !hasMore || _searchController.text.isNotEmpty) return;

    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/ingredientes?page=$page&limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> newIngredients = jsonDecode(response.body)['data'];
        setState(() {
          ingredients.addAll(newIngredients.map((ingredient) => {
                'id': ingredient['id'].toString(),
                'nombre': ingredient['nombre'],
                'imagen': ingredient['imagen']
              }));
          filteredIngredients = ingredients;
          page++;
          hasMore = newIngredients.isNotEmpty;
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterIngredients({int page = 1}) async {
    final searchText = _searchController.text.trim();
    if (searchText.isEmpty) {
      setState(() {
        filteredIngredients = ingredients;
      });
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse(
      '$baseUrl/buscar_ingredientes_tabla?query=$searchText&limit=$limit&page=$page',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> newIngredients = jsonDecode(response.body);
        setState(() {
          if (page == 1) {
            filteredIngredients = newIngredients
                .map((ingredient) => {
                      'id': ingredient['id'].toString(),
                      'nombre': ingredient['nombre'] ?? '',
                      'imagen': ingredient['imagen'] ?? '',
                    })
                .toList();
          } else {
            filteredIngredients.addAll(newIngredients
                .map((ingredient) => {
                      'id': ingredient['id'].toString(),
                      'nombre': ingredient['nombre'] ?? '',
                      'imagen': ingredient['imagen'] ?? '',
                    })
                .toList());
          }
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar ingredientes')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar al servidor')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if (_searchController.text.isEmpty) {
        fetchIngredients();
      } else {
        final nextPage = (filteredIngredients.length ~/ limit) + 1;
        _filterIngredients(page: nextPage);
      }
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

  Widget _buildTable() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredIngredients.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredIngredients.length) return _buildLoader();
        final ingredient = filteredIngredients[index];
        return Table(
          border: TableBorder(
            top: BorderSide.none,
            left: BorderSide(color: coral, width: 3),
            right: BorderSide(color: coral, width: 3),
            bottom: BorderSide(color: coral, width: 3),
            horizontalInside: BorderSide(color: coral, width: 3),
            verticalInside: BorderSide(color: coral, width: 3),
          ),
          columnWidths: {
            0: MediaQuery.sizeOf(context).width > minWidth
                ? FixedColumnWidth(100)
                : FlexColumnWidth(1),
            1: FlexColumnWidth(8),
            2: MediaQuery.sizeOf(context).width > minWidth
                ? FixedColumnWidth(160)
                : FlexColumnWidth(2.5),
          },
          children: [
            if (index == 0)
              TableRow(
                decoration: BoxDecoration(color: coral),
                children: [
                  tableCellHeader('ID'),
                  tableCellHeader('Nombre Ingrediente'),
                  tableCellHeader(''),
                ],
              ),
            TableRow(
              decoration: BoxDecoration(color: cream),
              children: [
                tableCell(ingredient['id']!, TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: tableCell(ingredient['nombre']!, TextAlign.start),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconButton(orange, "edit",
                          onPressed: () => widget.onEditPressed(ingredient)),
                      SizedBox(width: 10),
                      iconButton(red, "delete",
                          onPressed: () => deleteIngredient(ingredient)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoader() {
    return Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: green,
              )
            : Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (constraints.maxWidth > 550)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWidget(text: "Ingredientes", size: 45),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              controller: _searchController,
                              onChanged: (value) {
                                _filterIngredients(); // Llama a _filterIngredients cuando el texto cambie
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          TextButtonWidget(
                            onAddPressed: widget.onAddPressed,
                            wHorizontal: 55,
                            wVertical: 17,
                            fontSize: 25,
                            text: 'Agregar',
                          ),
                        ],
                      )
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWidget(text: "Ingredientes", size: 32),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double
                            .infinity, // Asegura un tamaño consistente en pantallas pequeñas
                        child: TextButtonWidget(
                          onAddPressed: widget.onAddPressed,
                          wHorizontal: 40,
                          wVertical: 13,
                          fontSize: 18,
                          text: 'Agregar',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double
                            .infinity, // Asegura que no haya error de restricciones
                        child: SearchBarWidget(
                          controller: _searchController,
                          onChanged: (value) {
                            _filterIngredients(); // Llama a _filterIngredients cuando el texto cambie
                          },
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 20),

                // Sección de tabla con scroll horizontal si el ancho es menor a minWidth
                if (constraints.maxWidth > minWidth)
                  Expanded(
                      child: _buildTable()) // Sin restricciones no definidas
                else
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 650,
                        child: _buildTable(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
