import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/screens/add_dish_screen.dart';
import 'package:warudu_web_app/screens/add_ingredient_screen.dart';
import 'package:warudu_web_app/screens/add_user_screen.dart';
import 'package:warudu_web_app/screens/user_table_screen.dart';
import 'package:warudu_web_app/screens/ingredient_table_screen.dart';
import '../screens/dish_table_screen.dart';
import '../constants.dart';

// Lista de entradas con iconos y textos para el NavigationRail
const List<Map<String, dynamic>> entries = [
  {'texto': 'Platillos', 'icono': Icons.restaurant_menu},
  {'texto': 'Ingredientes', 'icono': Icons.kitchen},
  {'texto': 'Usuarios', 'icono': Icons.people},
];

class AdminWidget extends StatefulWidget {
  final Map<String, dynamic>? userToEdit;
  final Map<String, dynamic>? ingredientToEdit;
  final Map<String, dynamic>? dishToEdit;
  final int initialIndex;

  const AdminWidget({
    this.userToEdit,
    this.ingredientToEdit,
    this.dishToEdit,
    this.initialIndex = 0,
  });

  @override
  State<AdminWidget> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminWidget> {
  late int selectedIndex;
  int lastMainSelectedIndex = 0;
  Map<String, dynamic>? currentUserToEdit;
  Map<String, dynamic>? currentIngredientToEdit;
  Map<String, dynamic>? currentDishToEdit;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    currentUserToEdit = widget.userToEdit;
    currentIngredientToEdit = widget.ingredientToEdit;
    currentDishToEdit = widget.dishToEdit;
  }

  void changeScreen(int index,
      {Map<String, dynamic>? userToEdit,
      Map<String, dynamic>? ingredientToEdit,
      Map<String, dynamic>? dishToEdit}) {
    setState(() {
      if (index < 3) {
        lastMainSelectedIndex = index;
      }
      selectedIndex = index;
      currentUserToEdit = userToEdit;
      currentIngredientToEdit = ingredientToEdit;
      currentDishToEdit = dishToEdit;
    });
  }

  void _editDish(Map<String, dynamic> dish) =>
      changeScreen(3, dishToEdit: dish);

  void _editIngredient(Map<String, dynamic> ingredient) =>
      changeScreen(4, ingredientToEdit: ingredient);

  void _editUser(Map<String, dynamic> user) =>
      changeScreen(5, userToEdit: user);

  @override
  Widget build(BuildContext context) {
    // Selección de pantalla basada en el índice seleccionado
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DishTableScreen(
          onAddPressed: () => changeScreen(3),
          onEditPressed: _editDish,
        );
        break;
      case 1:
        page = IngredientTableScreen(
          onAddPressed: () => changeScreen(4),
          onEditPressed: _editIngredient,
          // onDeletePressed: (ingredient) => _deleteItem('ingredientes', ingredient),
        );
        break;
      case 2:
        page = UserTableScreen(
          onAddPressed: () => changeScreen(5),
          onEditPressed: _editUser,
          // onDeletePressed: (user) => _deleteItem('usuarios', user),
        );
        break;
      case 3:
        page = AddDishScreen(
          dish: currentDishToEdit,
          isEditing: currentDishToEdit != null,
        );
        break;
      case 4:
        page = AddIngredientScreen(
          ingredient: currentIngredientToEdit,
          isEditing: currentIngredientToEdit != null,
        );
        break;
      case 5:
        page = AddUserScreen(
          user: currentUserToEdit,
          isEditing: currentUserToEdit != null,
        );
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              // Línea naranja izquierda
              Container(
                width: 14,
                color: coral,
              ),
              SafeArea(
                child: Container(
                  color: green,
                  width: constraints.maxWidth >= 1000 ? 250 : 72,
                  child: Column(
                    children: [
                      // Logo y título "Warudu" cuando el NavigationRail está extendido
                      if (constraints.maxWidth >= 1000)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Image.asset(
                                '../assets/images/warudu_logo_crema.png',
                                width: 110,
                                height: 110,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Warudu',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: cream,
                                ),
                              ),
                              // Línea decorativa debajo del logo
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                height: 6,
                                width: 180,
                                color: coral,
                              ),
                            ],
                          ),
                        ),
                      // NavigationRail con destinos generados desde entries
                      Expanded(
                        child: NavigationRail(
                          extended: constraints.maxWidth >= 1000,
                          backgroundColor: green,
                          indicatorColor: coral,
                          destinations: [
                            for (var entry in entries)
                              NavigationRailDestination(
                                icon: Icon(entry['icono'], color: Colors.white),
                                label: Text(
                                  entry['texto'],
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: cream,
                                  ),
                                ),
                              ),
                          ],
                          selectedIndex: selectedIndex < 3
                              ? selectedIndex
                              : lastMainSelectedIndex,
                          onDestinationSelected: (value) {
                            changeScreen(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Contenido Principal
              Expanded(
                child: Container(
                  color: cream,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
