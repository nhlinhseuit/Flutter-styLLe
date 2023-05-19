import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stylle/pages/home_page_delegated.dart';
import 'package:stylle/pages/profile_page_delegated.dart';
import 'package:stylle/pages/upload_image_page.dart';
import '../services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = AuthService.firebase().currentUser;

  int _selectedIndex = 0;

  final tabs = const [
    HomePageDelegated(),
    ImageCapture(),
    Center(child: Text('FAVORITE')),
    ProfilePageDelegated(),
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.values[0]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: Color.fromARGB(255, 160, 160, 160),
              blurRadius: 2.5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.white,
            activeColor: Colors.white,
            // tabBackgroundColor: const Color.fromRGBO(255, 191, 202, 100),
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(7),
            tabs: [
              GButton(
                icon: Icons.home,
                iconColor: Theme.of(context).colorScheme.primary,
                text: 'Home',
                gap: 6,
              ),
              GButton(
                icon: Icons.add_box_rounded,
                iconColor: Theme.of(context).colorScheme.primary,
                text: 'Add',
                gap: 6,
              ),
              GButton(
                icon: Icons.favorite_rounded,
                iconColor: Theme.of(context).colorScheme.primary,
                gap: 6,
                text: 'Favorite',
              ),
              GButton(
                icon: Icons.person_2,
                iconColor: Theme.of(context).colorScheme.primary,
                text: 'Profile',
                gap: 6,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
        ),
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
