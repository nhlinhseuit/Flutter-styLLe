import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/change_password_page.dart';
import 'package:stylle/pages/detail_page.dart';
import 'package:stylle/pages/edit_image_page.dart';
import 'package:stylle/pages/edit_info_page.dart';
import 'package:stylle/pages/forgot_password_page.dart';
import 'package:stylle/pages/home_page.dart';
import 'package:stylle/pages/login_page.dart';
import 'package:stylle/pages/pre_login_page.dart';
import 'package:stylle/pages/register_page.dart';
import 'package:stylle/pages/search_page.dart';
import 'package:stylle/pages/upload_image_page.dart';
import 'package:stylle/pages/user_profile_image.dart';
import 'package:stylle/pages/verify_page.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/services/notifiers/current_user.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Color(0xFFFF768E), // màu nền của thanh trạng thái
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
        home: const Splash(),
        routes: {
          preLoginRoute: (context) => const PreLoginPage(),
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          homeRoute: (context) => const HomePage(),
          verifyRoute: (context) => const VerifyEmailPage(),
          forgotPasswordRoute: (context) => const ForgotPasswordPage(),
          changePasswordRoute: (context) => const ChangePasswordPage(),
          editInfoRoute: (context) => const EditInfoPage(),
          detailPageRout: (context) => const DetailPage(),
          searchRoute: (context) => const SearchPage(),
          imageCaptureRoute: (context) => const ImageCapture(),
          editImageRoute: (context) => const EditImagePage(),
          userProfileUploadRoute: (context) => const UserProfileUpload(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          // brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFFF768E),
            secondary: Colors.black,
          ),
          textTheme: TextTheme(
              bodyMedium: GoogleFonts.poppins(
                  textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ))),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 300),
          child: Column(children: [
            Image.asset(
              "assets/images/camera.png",
              width: 80,
            ),
            Text(
            'styLLe',
            style: GoogleFonts.allura(
              color: const Color(0xFFFF768E),
              fontSize: 100,
            ),
          ),
          ]),
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
              final googleUser = AuthService.google().currentUser;
              if (googleUser != null) {
                return FutureBuilder(
                  future: MyUser.getCurrentUser(),
                  builder: (context, userSnapshot) {  
                    if (userSnapshot.connectionState == ConnectionState.done) {
                      Provider.of<CurrentUser>(context, listen: false).user =
                          userSnapshot.data!;
                      return const HomePage();
                    } else {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              }
              final emailUser = AuthService.firebase().currentUser;
              if (emailUser != null) {
                final emailVerified = emailUser.isEmailVerified;
                if (emailVerified) {
                  return FutureBuilder(
                    future: MyUser.getCurrentUser(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.done) {
                        Provider.of<CurrentUser>(context, listen: false).user =
                            userSnapshot.data!;
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
        });
  }
}
