import 'package:flutter/material.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/login_page.dart';
import 'package:stylle/pages/pre_login_page.dart';
import 'package:stylle/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: const BoardingPage(),
        routes: {
          preLoginRoute: (context) => const PreLoginPage(),
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
        },
        theme: ThemeData().copyWith(
          // change the focus border color of the TextField
          colorScheme: ThemeData().colorScheme.copyWith(primary: const Color.fromARGB(255, 252, 200, 209)),
        ),
    );
  }
}

