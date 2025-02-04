import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warudu_web_app/providers/auth_provider.dart'; // Importa AuthProvider
import '../colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false; // visibilidad de la contraseña
  int userType = 2; // Tipo de usuario administrador (asegúrate que sea el correcto)
  String email = "";
  String password = "";

  Future<void> _login() async {
    email = emailController.text;
    password = passwordController.text;

    // Verificación de campos vacíos
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    final response = await http.post(
        Uri.parse('$baseUrl/login_administrador'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'user_type': userType,
        }));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String username = data['username'];

      // Almacenar el estado de autenticación
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);

      // Actualizar el estado de autenticación en el AuthProvider
      Provider.of<AuthProvider>(context, listen: false).login();

      if (mounted) {
        Navigator.pushNamed(context, '/admin_widget');
      }
      print('Solicitud exitosa');
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión exitoso')),
      );
    } else {
      print('Error en la respuesta: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales no válidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              color: coral,
              padding: EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 480,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 46,
                            color: cream,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Correo:',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: cream,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cream,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Contraseña:',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: cream,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText:
                            !_isPasswordVisible, // Control visibilidad de la contraseña
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cream,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: coral,
                                size: 30.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            checkColor: isChecked ? coral : cream,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return cream; // Cuando está activo
                              }
                              return coral; // Cuando está inactivo
                            }),
                            side: BorderSide(color: cream),
                          ),
                          Text(
                            'Recuérdame',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: cream,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            _login();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: cream,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text(
                            'Ingresar',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: cream,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sección de Logo con fondo de imagen y filtro de color
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    '../assets/images/kitchen_utensils.jpg', // Ruta de la imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: green.withOpacity(0.9), // Filtro verde con opacidad
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '../assets/images/warudu_logo_crema.png',
                          width: 320,
                          height: 320,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Warudu',
                          style: GoogleFonts.inter(
                            fontSize: 46,
                            color: cream,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              color: cream,
            ),
          ),
        ],
      ),
    );
  }
}
