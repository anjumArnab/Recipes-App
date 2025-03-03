import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.withOpacity(0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(text, style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
        ),),
    );
  }
}