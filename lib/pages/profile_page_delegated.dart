import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/ellipsis_text.dart';
import 'package:stylle/components/user_images_viewer.dart';
import 'package:stylle/constants/enums.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/services/notifiers/current_user.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

import '../constants/routes.dart';

class ProfilePageDelegated extends StatefulWidget {
  const ProfilePageDelegated({super.key});

  @override
  State<ProfilePageDelegated> createState() => _ProfilePageDelegatedState();
}

class _ProfilePageDelegatedState extends State<ProfilePageDelegated> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      return Scaffold(
        floatingActionButton: PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) {
              return [
                if (!MyUser.isGoogleAuth)
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
                  final confirmLogout = await showLogOutDialog(context,
                      content: 'Logging out?', title: 'Log out');
                  if (confirmLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
                case MenuAction.changePassword:
                  Navigator.of(context).pushNamed(changePasswordRoute);
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                        Text(
                          currentUser.user.email,
                          overflow: TextOverflow.fade,
                        ),
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
