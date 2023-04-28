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
  bool _showFabMenu = false;

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
            fontSize: 52,
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            child: _showFabMenu
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'fab1',
                        onPressed: () {
                          // Do something when fab1 is pressed
                        },
                        tooltip: 'Fab 1',
                        child: const Icon(Icons.ac_unit),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: 'fab2',
                        onPressed: () {
                          // Do something when fab2 is pressed
                        },
                        tooltip: 'Fab 2',
                        child: const Icon(Icons.accessibility),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: 'fab3',
                        onPressed: () {
                          // Do something when fab3 is pressed
                        },
                        tooltip: 'Fab 3',
                        child: const Icon(Icons.adjust),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showFabMenu = !_showFabMenu;
              });
            },
            tooltip: 'Show menu',
            child: Icon(_showFabMenu ? Icons.close : Icons.menu),
          ),
        ]
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