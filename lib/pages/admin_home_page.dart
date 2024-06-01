import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stylle/pages/image_management_page.dart';
import 'package:stylle/pages/logging_page.dart';
import 'package:stylle/pages/user_management_page.dart';

import '../services/auth/auth_service.dart';
import '../utilities/check_connectivity.dart';
import 'tags_management_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final user = AuthService.firebase().currentUser;

  int _selectedIndex = 0;

  final tabs = const [
    UserManagementPage(),
    ImageManagementPage(),
    TagManagementPage(),
    LoggingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return FocusDetector(
      onVisibilityGained: () async {
        if (!(await checkInternetConnectivity())) {
          displayNoInternet();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: tabs,
        ),
        bottomNavigationBar: Container(
          // color: const Color(0xFF303030),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: Color(0xFF303030),
                blurRadius: 0,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              // tabBackgroundColor: const Color.fromRGBO(255, 191, 202, 100),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(7),
              tabs: [
                GButton(
                  icon: Icons.people,
                  iconColor: Theme.of(context).colorScheme.primary,
                  text: 'Users',
                  textColor: Colors.black,
                  gap: 6,
                ),
                GButton(
                  icon: Icons.image,
                  iconColor: Theme.of(context).colorScheme.primary,
                  text: 'Images',
                  textColor: Colors.black,
                  gap: 6,
                ),
                GButton(
                  icon: Icons.tag,
                  iconSize: 28,
                  iconColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.black,
                  gap: 6,
                  text: 'Tags',
                ),
                GButton(
                  icon: Icons.handyman,
                  iconColor: Theme.of(context).colorScheme.primary,
                  text: 'Logging',
                  textColor: Colors.black,
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
      ),
    );
    // } else {
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
  }
}
//     );
//   }
// }

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
