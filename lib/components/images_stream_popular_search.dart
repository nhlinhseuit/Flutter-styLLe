import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../constants/routes.dart';
import '../services/collections/my_images.dart';

class ImageStreamPopularSearch extends StatefulWidget {
  const ImageStreamPopularSearch({
    super.key, 
    this.user, 
    required this.imagesPopularStream,
  });
  final MyUser? user;
  final Stream<List<MyImage>> imagesPopularStream;
  @override
  State<ImageStreamPopularSearch> createState() => _ImageStreamPopularSearchState();
}

class _ImageStreamPopularSearchState extends State<ImageStreamPopularSearch> {
  late final StreamController<List<MyImage>> imagesPopularStreamController;

  @override
  void initState() {
    imagesPopularStreamController = StreamController.broadcast();
    super.initState();
    MyImage.readImagesStream(imagesPopularStreamController);
  }

  @override
  Widget build(BuildContext context) {
  return StreamBuilder(
    stream: widget.imagesPopularStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final images = snapshot.data;
        var numberOfImages = images!.length;
        for (var image in images) {
          precacheImage(NetworkImage(image.imagePath), context);
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(numberOfImages, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(detailPageRout, arguments: images[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        images[index].imagePath,
                        height: 250,
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
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