import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:warudu_web_app/screens/home_screen.dart';
import 'package:warudu_web_app/screens/login_screen.dart';
import 'package:warudu_web_app/widgets/admin_widget.dart';
import 'package:warudu_web_app/providers/auth_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

// Configuración de GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/login_screen',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/admin_widget',
      builder: (context, state) => AuthGuard(child: AdminWidget()),
    ),
  ],
);

// Middleware para proteger rutas
class AuthGuard extends StatelessWidget {
  final Widget child;
  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      Future.microtask(() => context.go('/login_screen'));
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
