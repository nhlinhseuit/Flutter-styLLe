import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/user_images_viewer.dart';
import 'package:stylle/constants/enums.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/notifiers/current_user.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

import '../constants/routes.dart';

class ProfilePageDelegated extends StatelessWidget {
  const ProfilePageDelegated({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      return Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 40),
              child: Row(
                children: [
                  CircleImage(size: 128, imgUrl: currentUser.user.profileImage),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentUser.user.getName),
                        Text(currentUser.user.email),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(200, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16), // <-- Radius
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: const Size(120, 32),
                            ),
                            child: const Text(
                              'Edit profile',
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(editInfoRoute);
                            }),
                      ],
                    ),
                  ),
                  PopupMenuButton<MenuAction>(
                      icon: const Icon(Icons.menu),
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem<MenuAction>(
                            value: MenuAction.logout,
                            child: Text('Logout'),
                          ),
                          PopupMenuItem<MenuAction>(
                            value: MenuAction.changePassword,
                            child: Text('Change password'),
                          )
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
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const UserImagesView()
          ],
        ),
      );
    });
  }
}
