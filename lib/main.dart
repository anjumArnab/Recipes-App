import 'package:company_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Company());
}

class Company extends StatelessWidget {
  const Company({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Company Info Manager",
      home: HomeScreen(),
    );
  }
}
