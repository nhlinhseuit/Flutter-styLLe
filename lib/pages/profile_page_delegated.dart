import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/services/auth/auth_service.dart';

import '../constants/routes.dart';

class ProfilePageDelegated extends StatelessWidget {
  const ProfilePageDelegated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: const Color.fromARGB(250, 250, 250, 255),
          toolbarHeight: 45,
          // elevation: 0.16,
          elevation: 2,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 100),
            child: Text(
              'PROFILE',
              style: GoogleFonts.allura(
                color: Colors.pink[200],
                fontSize: 35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
        ),
        body: TextButton(
            onPressed: () async {
              final confirmLogout = await showLogOutDialog(context);
                  if (confirmLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
            },
            child: Text(
              "LOG OUT?",
              style: GoogleFonts.abhayaLibre(
                  color: const Color.fromARGB(255, 100, 100, 100),
                  fontWeight: FontWeight.w800),
            )));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to log out'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ],
        );
      }).then((value) => value ?? false);
}