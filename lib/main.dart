import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/forgot_password_page.dart';
import 'package:stylle/pages/home_page.dart';
import 'package:stylle/pages/login_page.dart';
import 'package:stylle/pages/pre_login_page.dart';
import 'package:stylle/pages/register_page.dart';
import 'package:stylle/pages/verify_page.dart';
import 'package:stylle/services/auth/auth_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    statusBarColor: Colors.pink[200]!, // màu nền của thanh trạng thái
    statusBarIconBrightness: Brightness.dark, // màu icon trên thanh trạng thái
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
        routes: {
          preLoginRoute: (context) => const PreLoginPage(),
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          homeRoute: (context) => const HomePage(),
          verifyRoute: (context) => const VerifyEmailPage(),
          forgotPasswordRoute: (context) => const ForgotPasswordPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 252, 200, 209),
            secondary: Colors.black,
          ),
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.abhayaLibre(
              textStyle: const TextStyle(
                fontSize: 18,
              )
            )
          ),
        ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              final emailVerified = user.isEmailVerified;
              if (emailVerified) {
                return const HomePage();
              } else {
                return const VerifyEmailPage();
              }
            } else {
              return const BoardingPage();
            }
          default:
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
        }
      }
    );
  }
}

