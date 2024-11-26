import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: coral,
            ),
          ),
          Expanded(
            flex: 12,
            child: Container(
              color: green,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          '../assets/images/warudu_logo_crema.png',
                          width: 120,
                          height: 120,
                        ),
                        Text(
                          "Warudu",
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: cream,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 6,
                            color: coral,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                    Text(
                      "Platillos",
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: cream,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Ingredientes",
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: cream,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Usuarios",
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: cream,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 60,
            child: Container(
              color: cream,
            ),
          ),
        ],
      ),
    );
  }
}
