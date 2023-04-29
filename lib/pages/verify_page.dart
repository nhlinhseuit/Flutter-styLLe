import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/utilities/popup_dialog.dart';

import '../services/auth/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;
  
  Future<void> verifyEmail() async {
    await AuthService.firebase().sendEmailVerification();
  }

  @override
  void initState() {
    super.initState();
    verifyEmail();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await AuthService.firebase().reloadUser();
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        timer.cancel();
        if (!mounted) return;
        await showMessageDialog(context, 'Your email has been successfully verified.');
        Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance;
    // auth.authStateChanges().listen((user) {
    // final user = AuthService.firebase().currentUser;
    //   if (user != null) {
    //     if (user.isEmailVerified) {
    //           Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
    //     }
    //   }
    // });
    return Stack(
      children: [
        Image.asset(
          "assets/images/LoginBackground.png",
          fit: BoxFit.fill,
          height: (MediaQuery.of(context).size.height),
          width: (MediaQuery.of(context).size.width),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            // title: const Text("Login"),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Verify \nyour account",
                    style: GoogleFonts.abhayaLibre(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 36.00,
                        fontWeight: FontWeight.w900
                      )
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("We've sent you an email verification.\nIf you haven't receive your verification, please tap on the button below:"),
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        await AuthService.firebase().sendEmailVerification();
                      }, 
                      child: Text(
                        'Send email verification.',
                        style: GoogleFonts.abhayaLibre(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.00,
                          )
                        ),
                      )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () => {
                        Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false)
                      }, 
                      child: Text(
                        'Later',
                        style: GoogleFonts.abhayaLibre(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20.00,
                          )
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
            ]),
          ),
        ),
      ],
    );
  }
}
