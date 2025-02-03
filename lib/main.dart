import 'package:flutter/material.dart';
import 'package:warudu_web_app/screens/home_screen.dart';
import 'package:warudu_web_app/widgets/admin_widget.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

//flutter run -d chrome --web-port=8000
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login_screen',
        routes: {
          '/login_screen': (BuildContext context) => LoginScreen(),
          '/admin_widget': (BuildContext context) => AdminWidget(),
          '/': (BuildContext context) => HomeScreen(),
        });
  }
}
