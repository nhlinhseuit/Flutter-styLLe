import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/detail_page.dart';
import 'package:stylle/pages/forgot_password_page.dart';
import 'package:stylle/pages/home_page.dart';
import 'package:stylle/pages/login_page.dart';
import 'package:stylle/pages/pre_login_page.dart';
import 'package:stylle/pages/register_page.dart';
import 'package:stylle/pages/upload_image_page.dart';
import 'package:stylle/pages/user_profile_image.dart';
import 'package:stylle/pages/verify_page.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/services/notifiers/current_user.dart';

import 'pages/search_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 252, 200, 209), // màu nền của thanh trạng thái
    statusBarIconBrightness: Brightness.dark, // màu icon trên thanh trạng thái
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<CurrentUser>.value(
      value: CurrentUser(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const MainPage(),
          routes: {
            preLoginRoute: (context) => const PreLoginPage(),
            loginRoute: (context) => const LoginPage(),
            registerRoute: (context) => const RegisterPage(),
            homeRoute: (context) => const HomePage(),
            verifyRoute: (context) => const VerifyEmailPage(),
            forgotPasswordRoute: (context) => const ForgotPasswordPage(),
            detailPageRout: (context) => const DetailPage(),
            searchRoute:(context) => const SearchPage(),
            imageCaptureRoute: (context) => const ImageCapture(),
            userProfileUploadRoute: (context) => const UserProfileUpload(),
          },
          theme: ThemeData(
            // brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 252, 200, 209),
              secondary: Colors.black,
            ),
            textTheme: TextTheme(
              bodyMedium: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                )
              )
            ),
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
                return FutureBuilder(
                  future: MyUser.getCurrentUser(),
                  builder: (context, userSnapshot) {  
                    if (userSnapshot.connectionState == ConnectionState.done) {
                      Provider.of<CurrentUser>(context,listen: false).user = userSnapshot.data!;
                      return const HomePage();
                    } else {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              } else {
                return const VerifyEmailPage();
              }
            } else {
              return const BoardingPage();
            }
          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      }
    );
  }
} 

