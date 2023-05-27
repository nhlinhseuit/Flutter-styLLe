import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../constants/routes.dart';
import '../services/collections/my_images.dart';

class ImageStreamView extends StatefulWidget {
  const ImageStreamView({
    super.key, 
    required this.currentUser, 
    required this.imagesStream,
  });
  final MyUser currentUser;
  final Stream<List<MyImage>> imagesStream;
  @override
  State<ImageStreamView> createState() => _ImageStreamViewState();
}

class _ImageStreamViewState extends State<ImageStreamView> {
  List<bool> isUserFavorite = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.imagesStream,
      builder:(context, snapshot) {
        if (snapshot.hasData) {
          final images = snapshot.data;
          var numberOfImages = images!.length;
          for (var image in images) {
            isUserFavorite.add(image.isUserFavorite(widget.currentUser));
            image.isFavorite = image.isUserFavorite(widget.currentUser);
            precacheImage(NetworkImage(image.imagePath), context);
          }
          if (numberOfImages == 0) {
            return const Center(
              child: Text("You haven't liked any images! :("),
            );
          }
          return MasonryGridView.builder(
            itemCount: numberOfImages,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(                                
                            images[index].userName,
                            style: const TextStyle(
                              color: Colors.black38,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                            icon: images[index].isFavorite
                              ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary,) 
                              : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary,),
                            onPressed: () async { 
                              await widget.currentUser.handleFavorite(images[index]);
                              setState(() {
                                images[index].isFavorite = images[index].isUserFavorite(widget.currentUser);
                              });
                            },
                        ),
                      ],
                    )
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
  
  }
}