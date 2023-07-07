import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../constants/routes.dart';
import '../services/collections/my_images.dart';

class ImageStreamViewShort extends StatefulWidget {
  const ImageStreamViewShort({
    super.key, 
    required this.imagesStream,
  });
  final Stream<List<MyImage>> imagesStream;
  @override
  State<ImageStreamViewShort> createState() => _ImageStreamViewShortState();
}

class _ImageStreamViewShortState extends State<ImageStreamViewShort> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.imagesStream,
      builder:(context, snapshot) {
        if (snapshot.hasData) {
          final images = snapshot.data;
          var numberOfImages = images!.length;
          for (var image in images) {
            precacheImage(NetworkImage(image.imagePath), context);
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
  
  }
}