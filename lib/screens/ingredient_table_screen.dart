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
  final VoidCallback onAddPressed;
  final Function(Map<String, dynamic>) onEditPressed;

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
  String currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchIngredients();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_loadMore);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        currentSearchQuery = '';
        filteredIngredients = List.from(ingredients);
      });
    } else {
      currentSearchQuery = _searchController.text.trim();
      _filterIngredients(reset: true);
    }
  }

  Future<void> fetchIngredients({bool reset = false}) async {
    if (isLoading || !hasMore || currentSearchQuery.isNotEmpty) return;

    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/ingredientes?page=$page&limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newIngredients = (data['data'] as List)
            .map((ingredient) => _mapIngredient(ingredient))
            .toList();

        setState(() {
          if (reset) {
            ingredients.clear();
            filteredIngredients.clear();
            page = 1;
          }

          ingredients.addAll(newIngredients);
          filteredIngredients = List.from(ingredients);
          page++;
          hasMore = newIngredients.length == limit;
        });
      }
    } catch (e) {
      print('Error al cargar ingredientes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ingredientes')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Map<String, dynamic> _mapIngredient(dynamic ingredient) {
    return {
      'id': ingredient['id'].toString(),
      'nombre': ingredient['nombre'] ?? '',
      'imagen': ingredient['imagen'] ?? '',
    };
  }

  Future<void> _filterIngredients({bool reset = true}) async {
    if (currentSearchQuery.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
          '$baseUrl/ingredientes?query=$currentSearchQuery&page=${reset ? 1 : page}&limit=$limit');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newIngredients =
            (data['data'] as List).map((ing) => _mapIngredient(ing)).toList();

        setState(() {
          if (reset) {
            page = 2; // Prepara para la próxima página
            ingredients = newIngredients;
            filteredIngredients = newIngredients;
          } else {
            ingredients.addAll(newIngredients);
            filteredIngredients.addAll(newIngredients);
            page++;
          }
          hasMore = newIngredients.length == limit;
        });
      }
    } catch (e) {
      print('Error en búsqueda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar ingredientes')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMore) {
      if (currentSearchQuery.isEmpty) {
        fetchIngredients();
      } else {
        _filterIngredients(reset: false);
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
          filteredIngredients.removeWhere((i) => i['id'] == ingredient['id']);
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
                                _filterIngredients();
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
                        width: double.infinity,
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
                        width: double.infinity,
                        child: SearchBarWidget(
                          controller: _searchController,
                          onChanged: (value) {
                            _filterIngredients();
                          },
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (constraints.maxWidth > minWidth)
                  Expanded(child: _buildTable())
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
