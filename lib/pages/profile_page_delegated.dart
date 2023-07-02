import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/user_images_viewer.dart';
import 'package:stylle/constants/enums.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/notifiers/current_user.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

import '../components/image_stream_viewer.dart';
import '../constants/routes.dart';

class ProfilePageDelegated extends StatefulWidget {
  const ProfilePageDelegated({super.key});

  @override
  State<ProfilePageDelegated> createState() => _ProfilePageDelegatedState();
}

class _ProfilePageDelegatedState extends State<ProfilePageDelegated> {
  final List<String> _choiceChips = ['My posts', 'Favorites'];
  int _selectedChoiceIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      return FutureBuilder(
          future:
              AuthService.fetchSignInMethodsForEmail(currentUser.user.email),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Scaffold(
                  floatingActionButton: PopupMenuButton<MenuAction>(
                      icon: const Icon(Icons.menu),
                      color: Colors.white,
                      itemBuilder: (context) {
                        return [
                          if (!snapshot.data!.contains("google.com"))
                            const PopupMenuItem<MenuAction>(
                              value: MenuAction.changePassword,
                              child: Text('Change password'),
                            ),
                          const PopupMenuItem<MenuAction>(
                            value: MenuAction.logout,
                            child: Text('Logout'),
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        switch (value) {
                          case MenuAction.logout:
                            final confirmLogout = await showLogOutDialog(
                                context,
                                content: 'Logging out?',
                                title: 'Log out');
                            if (confirmLogout) {
                              await AuthService.firebase().logout();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute,
                                (_) => false,
                              );
                            }
                            break;
                          case MenuAction.changePassword:
                            Navigator.of(context)
                                .pushNamed(changePasswordRoute);
                        }
                      }),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endTop,
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 40),
                        child: Row(
                          children: [
                            CircleImage(
                                size: 128,
                                imgUrl: currentUser.user.profileImage),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(currentUser.user.getName),
                                  Text(
                                    currentUser.user.email,
                                    overflow: TextOverflow.fade,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        maximumSize: const Size(200, 32),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              16), // <-- Radius
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        minimumSize: const Size(120, 32),
                                      ),
                                      child: const Text(
                                        'Edit profile',
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(editInfoRoute);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 16,),
                          ChoiceChip(
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(_choiceChips[0]),
                            ),
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            selected: _selectedChoiceIndex == 0,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedChoiceIndex = selected ? 0 : -1;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ChoiceChip(
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(_choiceChips[1]),
                            ),
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            selected: _selectedChoiceIndex == 1,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedChoiceIndex = selected ? 1 : -1;
                              });
                            },
                          ),
                        ],
                      ),
                      _selectedChoiceIndex == 0
                          ? const UserImagesView()
                          : ImageStreamView(
                              user: Provider.of<CurrentUser>(context,
                                      listen: false)
                                  .user,
                              imagesStream: Provider.of<CurrentUser>(context,
                                      listen: false)
                                  .user
                                  .favoriteImagesStream()),
                    ],
                  ),
                );
              default:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
            }
          });
    });
  }
}
