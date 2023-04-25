import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/enums.dart';
import '../constants/routes.dart';
import '../services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = AuthService.firebase().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          'styLLe',
          style: GoogleFonts.allura(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 56,
          ),),
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final confirmLogout = await showLogOutDialog(context);
                  if (confirmLogout) {
                    await AuthService.firebase().logout();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false,);
                    }
                  }
                  break;
              }
            }
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Hi there  ",
                    style: GoogleFonts.abhayaLibre(
                      color: Colors.black,
                      fontSize: 16
                    )
                  ),
                  const WidgetSpan(
                    child: Icon(Icons.waving_hand_outlined, size: 16),
                  ),
                ],
              ),
            )   
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          )
        ],
      ),
    );
  
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
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            }, 
            child: const Text('Log out')),
        ],
      );
  }).then((value) => value ?? false);
}