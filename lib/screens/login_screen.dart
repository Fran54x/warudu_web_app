import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warudu_web_app/providers/auth_provider.dart'; // Importa AuthProvider
import '../colors.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
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
  int userType = 0;
  String email = "";
  String password = "";

  Future<void> _login() async {
    try {
      email = emailController.text;
      password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, complete todos los campos')),
        );
        return;
      }

      final response =
          await http.post(Uri.parse('$baseUrl/login_administrador'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': email,
                'password': password,
                'user_type': userType ?? 0,
              }));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String username = data['username'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.login();

        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/admin_widget',
                arguments: {'username': username});
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Inicio de sesión exitoso')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales no válidas')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al intentar contactar con el servidor: $e')),
      );
    }
  }

  Widget credentialsInputs() {
    return Column(
      children: [],
    );
  }

  Widget loginInputs(BuildContext context, double factor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 46 * factor,
              color: cream,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 50 * factor),
        Text(
          'Correo:',
          style: GoogleFonts.inter(
            fontSize: 22 * factor,
            fontWeight: FontWeight.w300,
            color: cream,
          ),
        ),
        SizedBox(height: 10 * factor),
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
        SizedBox(height: 20 * factor),
        Text(
          'Contraseña:',
          style: GoogleFonts.inter(
            fontSize: 22 * factor,
            fontWeight: FontWeight.w300,
            color: cream,
          ),
        ),
        SizedBox(height: 10 * factor),
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
                  size: 30.0 * factor,
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
        SizedBox(height: 20 * factor),
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
              padding: EdgeInsets.symmetric(vertical: 20 * factor),
            ),
            child: Text(
              'Ingresar',
              style: GoogleFonts.inter(
                fontSize: 22 * factor,
                fontWeight: FontWeight.bold,
                color: cream,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget computerDesignLogin() {
    return Row(
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
                child: loginInputs(context, 1),
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
                  'assets/images/kitchen_utensils.jpg', // Ruta de la imagen de fondo
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
                        'assets/images/warudu_logo_crema.png',
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
    );
  }

  Widget movileDesignLogin() {
    return Expanded(
        child: Container(
      color: coral,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            width: double.infinity,
            color: cream,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                color: green,
                child: Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/warudu_logo_crema.png',
                            width: 170,
                            height: 170,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Warudu',
                            style: GoogleFonts.inter(
                              fontSize: 40,
                              color: cream,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          loginInputs(context, 0.70),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.sizeOf(context).width > 700
          ? computerDesignLogin()
          : movileDesignLogin(),
    );
  }
}
