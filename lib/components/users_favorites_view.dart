import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylle/components/image_stream_viewer.dart';
import 'package:stylle/services/collections/my_images.dart';
import 'package:stylle/services/collections/my_users.dart';


class UsersFavoritesView extends StatefulWidget {
  const UsersFavoritesView({super.key, required this.currentUser});
  final MyUser currentUser;

  @override
  // ignore: library_private_types_in_public_api
  _UsersFavoritesViewState createState() =>
      _UsersFavoritesViewState();
}

class _UsersFavoritesViewState extends State<UsersFavoritesView> {
  List<MyImage> images = [];
  List<bool> isUserFavorite = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Timestamp? lastDocumentTimestamp;
  
  @override
  void initState() {
    super.initState();
    _fetchImages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchImages() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    // Fetch the next batch of images from Firestore
    QuerySnapshot snapshot;
    if (lastDocumentTimestamp == null) {
      snapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('id', whereIn: widget.currentUser.favorites)
          .limit(10)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('id', whereIn: widget.currentUser.favorites)
          .startAfter([lastDocumentTimestamp])
          .limit(10)
          .get();
    }

    List<MyImage> fetchedImages = snapshot.docs
        .map((doc) {
          final image = MyImage.fromJson(doc.data() as Map<String,dynamic>);
          isUserFavorite.add(image.isUserFavorite(widget.currentUser));
          precacheImage(NetworkImage(image.imagePath), context);
          return image;
        })
        .toList();


    setState(() {
      images.addAll(fetchedImages);
      isLoading = false;
      if (fetchedImages.isNotEmpty) {
        lastDocumentTimestamp =
            snapshot.docs.last['upload_time'] as Timestamp;
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImageStreamView(currentUser: widget.currentUser, imagesStream: widget.currentUser.favoriteImagesStream(),);
  //   return StreamBuilder(
  //     stream: _imagesStreamController.stream,
  //     builder:(context, snapshot) {
  //       if (snapshot.hasData) {
  //         final images = snapshot.data;
  //         var numberOfImages = images!.length;
  //         for (var image in images) {
  //           isUserFavorite.add(image.isUserFavorite(widget.currentUser));
  //           precacheImage(NetworkImage(image.imagePath), context);
  //         }
  //         return MasonryGridView.builder(
  //           itemCount: numberOfImages,
  //           gridDelegate:
  //               const SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //           ),
  //           itemBuilder: (context, index) {
  //             return Padding(
  //                 padding: const EdgeInsets.only(
  //                     top: 0, left: 8, right: 8, bottom: 20),
  //                 child: Column(
  //                   children: [
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.circular(20),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           Navigator.of(context)
  //                               .pushNamed(detailPageRout, arguments: images[index]);
  //                         },
  //                         child: CachedNetworkImage(
  //                           imageUrl: images[index].imagePath,
  //                           progressIndicatorBuilder: (context, url, downloadProgress) => 
  //                                   CircularProgressIndicator(value: downloadProgress.progress),
  //                           errorWidget: (context, url, error) => const Icon(Icons.error),
  //                         ),  
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 10.0, left: 14),
  //                           child: Text(                                
  //                             images[index].userName,
  //                             style: const TextStyle(
  //                               color: Colors.black38,
  //                             ),
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding:
  //                               const EdgeInsets.only(top: 8, left: 45),
  //                           child: IconButton(
  //                             icon: isUserFavorite[index] 
  //                               ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary,) 
  //                               : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary,),
  //                             onPressed: () async { 
  //                               await widget.currentUser.handleFavorite(images[index]);
  //                               setState(() {
  //                                 isUserFavorite[index] = images[index].isUserFavorite(widget.currentUser);
  //                               });
  //                             },
  //                         ),
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               )
  //             );
  //           }
  //         );      
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  }
}
