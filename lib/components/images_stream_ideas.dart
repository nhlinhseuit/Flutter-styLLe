import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/services/notifiers/current_user.dart';

import '../constants/routes.dart';
import '../services/collections/my_images.dart';
import '../utilities/check_connectivity.dart';

class ImageStreamIdeas extends StatefulWidget {
  const ImageStreamIdeas({
    super.key, 
    this.user, 
    required this.imagesTagsStream,
  });
  final MyUser? user;
  final Stream<List<MyImage>> imagesTagsStream;
  @override
  State<ImageStreamIdeas> createState() => _ImageStreamIdeasState();
}

class _ImageStreamIdeasState extends State<ImageStreamIdeas> {
  late final StreamController<List<MyImage>> imagesTagsStreamController;

  @override
  void initState() {
    imagesTagsStreamController = StreamController.broadcast();
    super.initState();
    MyImage.readImagesStream(imagesTagsStreamController);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser> (
      builder: (context, currentUser, child) {
        return StreamBuilder(
        stream: widget.imagesTagsStream,
        builder:(context, snapshot) {
          if (snapshot.hasData) {
            final images = snapshot.data;
            var numberOfImages = images!.length;
            for (var image in images) {
              image.isFavorite = image.isUserFavorite(currentUser.user);
              precacheImage(NetworkImage(image.imagePath), context);
            }
            if (numberOfImages == 0) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Center(
                        child: Text("No image found!"),
                      ),
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
                            onTap: () async {
                              if (!(await checkInternetConnectivity())) {
                                displayNoInternet();
                                return;
                              }
                              Navigator.of(context)
                                  .pushNamed(detailPageRout, arguments: images[index]);
                            },
                            child: CachedNetworkImage(
                              imageUrl: images[index].imagePath,
                              progressIndicatorBuilder: (context, url, downloadProgress) => 
                                      CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),  
                          ),
                        ),
                        
                    ],
                  )
                );
              }
            );      
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
      },
    );
  }
}