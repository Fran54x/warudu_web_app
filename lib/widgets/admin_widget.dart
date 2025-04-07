import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/screens/add_dish_screen.dart';
import 'package:warudu_web_app/screens/add_ingredient_screen.dart';
import 'package:warudu_web_app/screens/add_user_screen.dart';
import 'package:warudu_web_app/screens/user_table_screen.dart';
import 'package:warudu_web_app/screens/ingredient_table_screen.dart';
import 'package:warudu_web_app/screens/dish_table_screen.dart';
import 'package:warudu_web_app/providers/auth_provider.dart';

const List<Map<String, dynamic>> entries = [
  {'texto': 'Platillos', 'icono': Icons.restaurant_menu},
  {'texto': 'Ingredientes', 'icono': Icons.kitchen},
  {'texto': 'Usuarios', 'icono': Icons.people},
];

double minWidth = 1100;

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
  State<AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
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
    final authProvider = Provider.of<AuthProvider>(context);

    /*if (!authProvider.isAuthenticated) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login_screen'));
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }*/

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
        );
        break;
      case 2:
        page = UserTableScreen(
          onAddPressed: () => changeScreen(5),
          onEditPressed: _editUser,
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
              Container(width: 14, color: coral),
              SafeArea(
                child: Container(
                  color: green,
                  width: constraints.maxWidth >= minWidth ? 250 : 72,
                  child: Column(
                    children: [
                      if (constraints.maxWidth >= minWidth)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Image(
                                image: AssetImage(
                                    'assets/images/warudu_logo_crema.png'),
                                width: 110,
                                height: 110,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Warudu',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: cream,
                                ),
                              ),
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
                      Expanded(
                        child: NavigationRail(
                          extended: constraints.maxWidth >= minWidth,
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
                      SizedBox(height: 10),
                      // Botón de cerrar sesión
                      TextButton.icon(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pushReplacementNamed(
                              context, '/login_screen');
                        },
                        icon: Center(
                          child: Icon(Icons.logout,
                              color: (constraints.maxWidth >= minWidth)
                                  ? cream
                                  : Colors.white),
                        ),
                        label: Text(
                          (constraints.maxWidth >= minWidth)
                              ? 'Cerrar sesión'
                              : '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: cream,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container(color: cream, child: page)),
            ],
          ),
        );
      },
    );
  }
}
