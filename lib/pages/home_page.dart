import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stylle/pages/favorites_page.dart';
import 'package:stylle/pages/home_page_delegated.dart';
import 'package:stylle/pages/profile_page_delegated.dart';
import 'package:stylle/pages/search_page.dart';
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
    SearchPage(),
    ProfilePageDelegated(),
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.values[0]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // return FutureBuilder(
    //   future: MyUser.getCurrentUser(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Provider.of<CurrentUser>(context,listen: false).user = snapshot.data!;
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: tabs,
            ),
            bottomNavigationBar: Container(
              // color: const Color(0xFF303030),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                      icon: Icons.home,
                      iconColor: Theme.of(context).colorScheme.primary,
                      text: 'Home',
                      textColor: Colors.black,
                      gap: 6,
                    ),
                    GButton(
                      icon: Icons.add_box_rounded,
                      iconColor: Theme.of(context).colorScheme.primary,
                      text: 'Add',
                      textColor: Colors.black,
                      gap: 6,
                    ),
                    GButton(
                      icon: Icons.search_rounded,
                      iconSize: 28,
                      iconColor: Theme.of(context).colorScheme.primary,
                      textColor: Colors.black,
                      gap: 6,
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.person_2,
                      iconColor: Theme.of(context).colorScheme.primary,
                      text: 'Profile',
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
