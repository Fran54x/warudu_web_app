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

const minWidth = 1000.0;

class DishTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed;
  final Function(Map<String, dynamic>) onEditPressed;

  DishTableScreen({required this.onAddPressed, required this.onEditPressed});

  @override
  _DishTableScreenState createState() => _DishTableScreenState();
}

class _DishTableScreenState extends State<DishTableScreen> {
  List<Map<String, dynamic>> dishes = [];
  List<Map<String, dynamic>> filteredDishes = [];
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
    fetchDishes();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_loadMore);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        currentSearchQuery = '';
        filteredDishes = List.from(dishes);
      });
    } else {
      currentSearchQuery = _searchController.text.trim();
      _filterDishes(reset: true);
    }
  }

  Future<void> fetchDishes() async {
    if (isLoading || !hasMore || currentSearchQuery.isNotEmpty) return;

    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/platillos?page=$page&limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newDishes =
            (data['data'] as List).map((dish) => _mapDish(dish)).toList();

        setState(() {
          dishes.addAll(newDishes);
          filteredDishes = List.from(dishes);
          page++;
          hasMore = newDishes.length == limit;
        });
      }
    } catch (e) {
      print('Error al cargar platillos: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Map<String, dynamic> _mapDish(dynamic dish) {
    return {
      'id': dish['id'].toString(),
      'nombre': dish['nombre'],
      'imagen': dish['imagen'],
      'descripcion': dish['descripcion'],
      'preparacion': dish['preparacion'],
      'tiempo': dish['tiempo'] ?? 0,
      'ingredientes': dish['ingredientes'],
    };
  }

  Future<void> _filterDishes({bool reset = true}) async {
    if (currentSearchQuery.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
          '$baseUrl/platillos?query=$currentSearchQuery&page=${reset ? 1 : page}&limit=$limit');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newDishes =
            (data['data'] as List).map((dish) => _mapDish(dish)).toList();

        setState(() {
          if (reset) {
            page = 2; // Prepara para la próxima página
            dishes = newDishes;
            filteredDishes = newDishes;
          } else {
            dishes.addAll(newDishes);
            filteredDishes.addAll(newDishes);
            page++;
          }
          hasMore = newDishes.length == limit;
        });
      }
    } catch (e) {
      print('Error en búsqueda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar platillos')),
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
        fetchDishes();
      } else {
        _filterDishes(reset: false);
      }
    }
  }

  Future<void> deleteDish(Map<String, dynamic> dish) async {
    final url = Uri.parse('$baseUrl/eliminar_platillo/${dish['id']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          dishes.removeWhere((d) => d['id'] == dish['id']);
          filteredDishes.removeWhere((d) => d['id'] == dish['id']);
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

  // El resto del código (build, _buildTable, etc.) permanece igual
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
                      TitleWidget(text: "Platillos", size: 45),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              controller: _searchController,
                              onChanged: (value) {
                                _filterDishes();
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
                      TitleWidget(text: "Platillos", size: 32),
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
                            _filterDishes();
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
                        width: 910,
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

  Widget _buildTable() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredDishes.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredDishes.length) return _buildLoader();
        final dish = filteredDishes[index];
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
                : FlexColumnWidth(0.5),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(0.8),
            3: MediaQuery.sizeOf(context).width > minWidth
                ? FixedColumnWidth(160)
                : FlexColumnWidth(1)
          },
          children: [
            if (index == 0)
              TableRow(
                decoration: BoxDecoration(color: coral),
                children: [
                  tableCellHeader('ID'),
                  tableCellHeader('Nombre Platillo'),
                  tableCellHeader('Tiempo'),
                  tableCellHeader(''),
                ],
              ),
            TableRow(
              decoration: BoxDecoration(color: cream),
              children: [
                tableCell(dish['id']!, TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: tableCell(dish['nombre']!, TextAlign.start),
                ),
                tableCell('${dish['tiempo']} min', TextAlign.center),
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
}
