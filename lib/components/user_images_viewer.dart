import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stylle/services/notifiers/current_user.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

import '../constants/enums.dart';
import '../constants/routes.dart';
import '../services/collections/my_images.dart';
import '../utilities/check_connectivity.dart';

class UserImagesView extends StatefulWidget {
  const UserImagesView({super.key});
  @override
  State<UserImagesView> createState() => UserImagesViewState();
}

class UserImagesViewState extends State<UserImagesView> {
  late final StreamController<List<MyImage>> imagesStreamController;

  @override
  void initState() {
    imagesStreamController = StreamController.broadcast();
    super.initState();
    MyImage.readImagesStream(imagesStreamController);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkInternetConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.data!) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text("No internet connecttion."),
              ),
            );
          }
        return Consumer<CurrentUser>(
          builder: (context, currentUser, child) {
            return StreamBuilder(
              stream: currentUser.user.userImagesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final images = snapshot.data;
                  var numberOfImages = images!.length;
                  for (var image in images) {
                    image.isFavorite = image.isUserFavorite(currentUser.user);
                    precacheImage(NetworkImage(image.imagePath), context);
                  }
                  if (numberOfImages == 0) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          const Center(
                            child: Text("It's empty here."),
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(imageCaptureRoute);
                                },
                                child: const Text("Upload something?")),
                          )
                        ],
                      ),
                    );
                  }
                  return MasonryGridView.builder(
                      shrinkWrap: true,
                      itemCount: numberOfImages,
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 8, right: 8, bottom: 20),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          detailPageRout,
                                          arguments: images[index]);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: images[index].imagePath,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: images[index].isFavorite
                                          ? Icon(
                                              Icons.favorite,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      onPressed: () async {
                                        if (!(await checkInternetConnectivity())) {
                                          displayNoInternet();
                                          return;
                                        }
                                        await currentUser.user
                                            .handleFavorite(images[index]);
                                        setState(() {
                                          images[index].isFavorite =
                                              !images[index].isFavorite;
                                          Provider.of<CurrentUser>(context,
                                                      listen: false)
                                                  .userFavorites =
                                              currentUser.user.favorites;
                                        });
                                      },
                                    ),
                                    PopupMenuButton<MyImageAction>(
                                        color: Colors.white70,
                                        itemBuilder: (context) {
                                          return const [
                                            PopupMenuItem<MyImageAction>(
                                              value: MyImageAction.update,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.edit),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<MyImageAction>(
                                              value: MyImageAction.delete,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.delete_outline),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text('Delete'),
                                                ],
                                              ),
                                            )
                                          ];
                                        },
                                        onSelected: (value) async {
                                          switch (value) {
                                            case MyImageAction.update:
                                              Navigator.of(context).popAndPushNamed(
                                                  editImageRoute,
                                                  arguments: images[index]);
                                              break;
                                            case MyImageAction.delete:
                                              final confirmLogout =
                                                  await showLogOutDialog(context,
                                                      content:
                                                          'Delete this image?\nThis action cannot be revert.',
                                                      title: 'Delete');
                                              if (confirmLogout) {
                                                images[index].delete();
                                                Navigator.of(context).pop();
                                              }
                                          }
                                        }),
                                  ],
                                )
                              ],
                            ));
                      });
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        );
      }
    );
  }
}
