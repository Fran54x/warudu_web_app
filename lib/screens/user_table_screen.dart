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

class UserTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed;
  final Function(Map<String, dynamic>) onEditPressed;

  UserTableScreen({required this.onAddPressed, required this.onEditPressed});

  @override
  _UserTableScreenState createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
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
    fetchUsers();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_loadMore);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        currentSearchQuery = '';
        filteredUsers = List.from(users);
      });
    } else {
      currentSearchQuery = _searchController.text.trim();
      _filterUsers(reset: true);
    }
  }

  Future<void> fetchUsers({bool reset = false}) async {
    if (isLoading || !hasMore || currentSearchQuery.isNotEmpty) return;

    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/usuarios?page=$page&limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newUsers =
            (data['data'] as List).map((user) => _mapUser(user)).toList();

        setState(() {
          if (reset) {
            users.clear();
            filteredUsers.clear();
            page = 1;
          }

          users.addAll(newUsers);
          filteredUsers = List.from(users);
          page++;
          hasMore = newUsers.length == limit;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar usuarios')),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar con el servidor: Error 503')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Map<String, dynamic> _mapUser(dynamic user) {
    return {
      'id': user['id'].toString(),
      'nombre': user['nombre'] ?? '',
      'correo': user['correo'] ?? '',
      'imagen': user['imagen'] ?? '',
      'password': user['password'] ?? '',
      'tipo_usuario': user['tipo_usuario'] ?? '',
    };
  }

  Future<void> _filterUsers({bool reset = true}) async {
    if (currentSearchQuery.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
          '$baseUrl/usuarios?query=$currentSearchQuery&page=${reset ? 1 : page}&limit=$limit');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newUsers =
            (data['data'] as List).map((user) => _mapUser(user)).toList();

        setState(() {
          if (reset) {
            page = 2;
            users = newUsers;
            filteredUsers = newUsers;
          } else {
            users.addAll(newUsers);
            filteredUsers.addAll(newUsers);
            page++;
          }
          hasMore = newUsers.length == limit;
        });
      }
    } catch (e) {
      print('Error en búsqueda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar usuarios')),
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
        fetchUsers();
      } else {
        _filterUsers(reset: false);
      }
    }
  }

  Future<void> deleteUser(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/eliminar_usuario/${user['id']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((u) => u['id'] == user['id']);
          filteredUsers.removeWhere((u) => u['id'] == user['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario eliminado exitosamente')),
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
      itemCount: filteredUsers.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredUsers.length) return _buildLoader();
        final user = filteredUsers[index];
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
            1: FlexColumnWidth(6),
            2: FlexColumnWidth(6),
            3: MediaQuery.sizeOf(context).width > minWidth
                ? FixedColumnWidth(160)
                : FlexColumnWidth(2.5),
          },
          children: [
            if (index == 0)
              TableRow(
                decoration: BoxDecoration(color: coral),
                children: [
                  tableCellHeader('ID'),
                  tableCellHeader('Nombre'),
                  tableCellHeader('Correo'),
                  tableCellHeader(''),
                ],
              ),
            TableRow(
              decoration: BoxDecoration(color: cream),
              children: [
                tableCell(user['id']!, TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: tableCell(user['nombre']!, TextAlign.start),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: tableCell(user['correo']!, TextAlign.start),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconButton(orange, "edit",
                          onPressed: () => widget.onEditPressed(user)),
                      SizedBox(width: 10),
                      iconButton(red, "delete",
                          onPressed: () => deleteUser(user)),
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
                      TitleWidget(text: "Usuarios", size: 45),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              controller: _searchController,
                              onChanged: (value) {
                                _filterUsers();
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
                      TitleWidget(text: "Usuarios", size: 32),
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
                            _filterUsers();
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
                        width: 900,
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
