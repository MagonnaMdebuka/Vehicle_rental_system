import 'package:flutter/material.dart';
import 'package:vehicle_rental/login_page.dart';
import 'package:vehicle_rental/vehicles_page.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {'/vehicles': (context) => const VehiclesPage(),},
      debugShowCheckedModeBanner: false,
    );
  }
}
