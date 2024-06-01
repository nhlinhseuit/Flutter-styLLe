import 'package:flutter/material.dart';

class ColumnField extends StatelessWidget {
  const ColumnField({super.key, required this.name, this.color});

  final String name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        softWrap: true,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
