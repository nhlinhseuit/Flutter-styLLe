import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stylle/services/collections/my_images.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/services/notifiers/current_user.dart';

import '../constants/routes.dart';
import '../utilities/check_connectivity.dart';

class InfiniteScrollableImageList extends StatefulWidget {
  const InfiniteScrollableImageList({super.key, required this.currentUser});
  final MyUser currentUser;

  @override
  // ignore: library_private_types_in_public_api
  _InfiniteScrollableImageListState createState() =>
      _InfiniteScrollableImageListState();
}

class _InfiniteScrollableImageListState extends State<InfiniteScrollableImageList> {
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
          .orderBy('upload_time')
          .limit(10)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('images')
          .orderBy('upload_time')
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
    var numberOfimages = images.length;
    return Consumer<CurrentUser>(
      builder: (context, currentUser, child) {
        return MasonryGridView.builder(
        itemCount: numberOfimages,
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 14),
                        child: Text(                                
                          images[index].userName,
                          style: const TextStyle(
                            color: Colors.black38,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 45),
                        child: IconButton(
                          icon: isUserFavorite[index] 
                            ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary,) 
                            : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary,),
                          onPressed: () async { 
                            await currentUser.user.handleFavorite(images[index]);
                            context.watch<CurrentUser>().userFavorites = currentUser.user.favorites;
                            setState(() {
                              isUserFavorite[index] = images[index].isUserFavorite(widget.currentUser);
                            });
                          },
                      ),
                    ),
                  ],
                )
              ],
            )
          );
        }
      );
      },
    );      
  }
}
