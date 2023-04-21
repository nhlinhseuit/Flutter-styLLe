import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylle/constants/routes.dart';

import '../services/auth/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    // final auth = AuthService.firebase().instance();
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
    final user = AuthService.firebase().currentUser;
      if (user != null) {
        if (user.isEmailVerified) {
              Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text("We've sent you an email verification."),
          const Text("If you haven't receive your verification, please tap on the button below:"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            }, 
            child: const Text('Send email verification.')
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false)
            }, 
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            }, 
            child: const Text('Sign out'),
          )
      ]),
    );
  }
}
