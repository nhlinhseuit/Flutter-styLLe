import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/user_images_viewer.dart';
import 'package:stylle/constants/enums.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/notifiers/current_user.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

import '../components/image_stream_viewer.dart';
import '../constants/routes.dart';
import '../utilities/check_connectivity.dart';

class ProfilePageDelegated extends StatefulWidget {
  const ProfilePageDelegated({super.key});

  @override
  State<ProfilePageDelegated> createState() => _ProfilePageDelegatedState();
}

class _ProfilePageDelegatedState extends State<ProfilePageDelegated> {
  bool changesMade = false;
  final List<String> _choiceChips = ['My posts', 'Favorites'];
  int _selectedChoiceIndex = 0;
  String imagePath =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541';

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      imagePath = currentUser.user.profileImage;
      return Stack(
        children: [
          FocusDetector(
            onVisibilityGained: () {
              if (changesMade) {
                setState(() {
                  imagePath = currentUser.user.profileImage;
                  changesMade = false;
                });
              }
            },
            child: FutureBuilder(
                future: AuthService.fetchSignInMethodsForEmail(
                    currentUser.user.email),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Scaffold(
                        floatingActionButton: PopupMenuButton<MenuAction>(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                            itemBuilder: (context) {
                              return [
                                if (!(snapshot.data!.contains("google.com") &&
                                    snapshot.data!.length == 1))
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
                              if (!(await checkInternetConnectivity())) {
                                displayNoInternet();
                                return;
                              }
                              switch (value) {
                                case MenuAction.logout:
                                  final confirmLogout = await showLogOutDialog(
                                      context,
                                      content: 'Logging out?',
                                      title: 'Log out');
                                  if (confirmLogout) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      loginRoute,
                                      (_) => false,
                                    );
                                    await AuthService.firebase().logout();
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
                                  CircleImage(size: 128, imgUrl: imagePath),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16), // <-- Radius
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              minimumSize: const Size(120, 32),
                                            ),
                                            child: const Text(
                                              'Edit profile',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              if (!(await checkInternetConnectivity())) {
                                                displayNoInternet();
                                                return;
                                              }
                                              setState(() {
                                                changesMade = true;
                                              });
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
                                const SizedBox(
                                  width: 16,
                                ),
                                ChoiceChip(
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(_choiceChips[0]),
                                  ),
                                  selectedColor:
                                      Theme.of(context).colorScheme.primary,
                                  selected: _selectedChoiceIndex == 0,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _selectedChoiceIndex = selected ? 0 : 1;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ChoiceChip(
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(_choiceChips[1]),
                                  ),
                                  selectedColor:
                                      Theme.of(context).colorScheme.primary,
                                  selected: _selectedChoiceIndex == 1,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _selectedChoiceIndex = selected ? 1 : 0;
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
                                    imagesStream: Provider.of<CurrentUser>(
                                            context,
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
                }),
          ),
          Positioned(
            top: 150,
            right: 30,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(imageManagementPage);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 210,
            right: 30,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(loggingPage);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(
                  Icons.note,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
