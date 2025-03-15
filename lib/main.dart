import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warudu_web_app/screens/home_screen.dart';
import 'package:warudu_web_app/screens/privacy_notice.dart';
import 'package:warudu_web_app/widgets/admin_widget.dart';
import 'package:warudu_web_app/screens/login_screen.dart';
import 'package:warudu_web_app/providers/auth_provider.dart'; // Importamos el AuthProvider

//flutter run -d chrome --web-port 8000
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/privacy_notice',
      routes: {
        '/login_screen': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/privacy_notice': (BuildContext context) => PrivacyNotice(),
        '/admin_widget': (BuildContext context) =>
            AuthGuard(child: AdminWidget()), // Ruta protegida
      },
    );
  }
}

// Middleware para proteger rutas
class AuthGuard extends StatelessWidget {
  final Widget child;
  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Si no está autenticado, lo redirige al Login
    if (!authProvider.isAuthenticated) {
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, '/login_screen'));
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
