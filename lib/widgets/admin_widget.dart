import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';
import 'package:warudu_web_app/screens/add_dish_screen.dart';
import 'package:warudu_web_app/screens/add_ingredient_screen.dart';
import 'package:warudu_web_app/screens/add_user_screen%20copy.dart';
import 'package:warudu_web_app/screens/user_table_screen.dart';
import '../screens/dish_table_screen.dart';
import '../screens/ingredient_table_screen.dart';

// Lista de entradas con iconos y textos para el NavigationRail
final List<Map<String, dynamic>> entries = [
  {'texto': 'Platillos', 'icono': Icons.restaurant_menu},
  {'texto': 'Ingredientes', 'icono': Icons.kitchen},
  {'texto': 'Usuarios', 'icono': Icons.people},
];

class AdminWidget extends StatefulWidget {
  @override
  State<AdminWidget> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminWidget> {
  var selectedIndex = 0;
  int lastMainSelectedIndex = 0;

  // Método para cambiar el índice seleccionado
  void changeScreen(int index) {
    setState(() {
      if (index < 3) {
        lastMainSelectedIndex = index;
      }
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Selección de pantalla basada en el índice seleccionado
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DishTableScreen(onAddPressed: () => changeScreen(3));
        break;
      case 1:
        page = IngredientTableScreen(onAddPressed: () => changeScreen(4));
        break;
      case 2:
        page = UserTableScreen(onAddPressed: () => changeScreen(5));
        break;
      case 3:
        page = AddDishScreen();
        break;
      case 4:
        page = AddIngredientScreen();
        break;
      case 5:
        page = AddUserScreen();
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
                color: coral, // Color Naranja
              ),
              SafeArea(
                child: Container(
                  color: green, // Color Verde de fondo del menú
                  width: constraints.maxWidth >= 1000 ? 250 : 72,
                  child: Column(
                    children: [
                      // Logo y título "Warudu" cuando el NavigationRail está extendido
                      if (constraints.maxWidth >= 1000)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Image.asset(
                                '../assets/images/warudu_logo_crema.png',
                                width: 110,
                                height: 110,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Warudu',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: cream, // Color Crema
                                ),
                              ),
                              // Línea decorativa debajo del logo
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                height: 6,
                                width: 180,
                                color: coral, // Color Naranja para la línea
                              ),
                            ],
                          ),
                        ),
                      // NavigationRail con destinos generados desde entries
                      Expanded(
                        child: NavigationRail(
                          extended: constraints.maxWidth >= 1000,
                          backgroundColor: green, // Color Verde
                          indicatorColor: coral, // Color Naranja para el indicador
                          destinations: [
                            for (var entry in entries.take(3))
                              NavigationRailDestination(
                                icon: Icon(
                                  entry['icono'],
                                  color: Colors.white,
                                ),
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
              // Contenido principal
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
