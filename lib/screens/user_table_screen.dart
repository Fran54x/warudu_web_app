import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/components/icon_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../colors.dart';
import '../widgets/table_widget.dart';
import '../constants.dart';

class UserTableScreen extends StatefulWidget {
  final VoidCallback onAddPressed; // Callback para agregar usuario
  final Function(Map<String, dynamic>) onEditPressed; // Callback para editar usuario

  UserTableScreen({required this.onAddPressed, required this.onEditPressed});

  @override
  _UserTableScreenState createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(_filterUsers);
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/usuarios');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          users = data.map((user) {
            return {
              'id': user['id'].toString(),
              'nombre': user['nombre'],
              'correo': user['correo'],
              'imagen': user['imagen'], // Asumiendo que también tienes la imagen
              'password': user['password'],
              'tipo_usuario': user['tipo_usuario'],
            };
          }).toList();
          filteredUsers = users;
        });
      } else {
        print('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteUser(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/eliminar_usuario/${user['id']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((u) => u['id'] == user['id']);
          filteredUsers = users;
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

  void _filterUsers() {
    setState(() {
      if (_isNumeric(_searchController.text)) {
        filteredUsers = users
            .where((user) => user['id'].contains(_searchController.text))
            .toList();
      } else {
        filteredUsers = users
            .where((user) => user['nombre'].toLowerCase().contains(_searchController.text.toLowerCase()))
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

  void _editUser(Map<String, dynamic> user) {
    widget.onEditPressed(user);
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
              "Usuarios",
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
                onPressed: widget.onAddPressed, // Acción para agregar un nuevo usuario
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
          // Tabla de usuarios con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: coral, width: 3),
                columnWidths: {
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(140),
                },
                children: [
                  // Encabezados de la tabla
                  TableRow(
                    decoration: BoxDecoration(color: coral),
                    children: [
                      tableCellHeader('ID'),
                      tableCellHeader('Nombre de Usuario'),
                      tableCellHeader('Correo'),
                      tableCellHeader(''),
                    ],
                  ),
                  // Filas de la tabla filtrada
                  for (var user in filteredUsers)
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
                              iconButton(orange, "edit", onPressed: () => _editUser(user)),
                              SizedBox(width: 10),
                              iconButton(red, "delete", onPressed: () => deleteUser(user)),
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
