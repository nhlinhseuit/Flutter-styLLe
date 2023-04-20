import 'package:flutter/material.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/pre_login_page.dart';
import 'package:stylle/pages/slide.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
        home: BoardingPage(),
    );
  }
}

