import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:company_app/screens/loginpage.dart';

void main() {
  runApp(const Company());
}

class Company extends StatelessWidget {
  const Company({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme()
      ),
      title: "Recipe App",
      home: const LoginPage(),
    );
  }
}
