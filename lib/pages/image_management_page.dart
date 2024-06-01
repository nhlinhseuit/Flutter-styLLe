import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stylle/constants/colors.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_images.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

class ImageManagementPage extends StatefulWidget {
  const ImageManagementPage({super.key});

  @override
  State<ImageManagementPage> createState() => _ImageManagementPageState();
}

class _ImageManagementPageState extends State<ImageManagementPage> {
  @override
  Widget build(BuildContext context) {
    var imagesStream = MyImage.imagesStream();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image management page'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              final confirmLogout = await showLogOutDialog(context,
                  content: 'Logging out?', title: 'Log out');

              if (confirmLogout) {
                await AuthService.firebase().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withAlpha(100),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: StreamBuilder(
            stream: imagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final images = snapshot.data;
                var numberOfImages = images!.length;
                for (var image in images) {
                  precacheImage(NetworkImage(image.imagePath), context);
                }
                return ListView.builder(
                    itemCount: numberOfImages,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          margin: const EdgeInsets.only(
                            bottom: 8,
                            left: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                margin: const EdgeInsets.only(
                                  left: 4,
                                ),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFfff7e6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: images[index].imagePath,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      images[index].userName,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                  // SizedBox(
                                  //   width:
                                  //       MediaQuery.of(context).size.width - 150,
                                  //   child: Text(
                                  //     listNewsData[index].desc,
                                  //     maxLines: 2,
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: AppTextStyles.appbarTitle.copyWith(
                                  //       color: Colors.grey,
                                  //       fontWeight: FontWeight.w200,
                                  //       fontSize: 12,
                                  //     ),
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            color: primaryPinkColor,
                                            Icons.favorite_rounded,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            // if (!(await checkInternetConnectivity())) {
                                            //   displayNoInternet();
                                            //   return;
                                            // }
                                            // await currentUser.user
                                            //     .handleFavorite(args);
                                            // setState(() {
                                            //   Provider.of<CurrentUser>(context,
                                            //               listen: false)
                                            //           .userFavorites =
                                            //       currentUser.user.favorites;
                                          }),
                                      Text(
                                        images[index].likes.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                            color: primaryPinkColor,
                                            Icons.report,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            // if (!(await checkInternetConnectivity())) {
                                            //   displayNoInternet();
                                            //   return;
                                            // }
                                            // await currentUser.user
                                            //     .handleFavorite(args);
                                            // setState(() {
                                            //   Provider.of<CurrentUser>(context,
                                            //               listen: false)
                                            //           .userFavorites =
                                            //       currentUser.user.favorites;
                                          }),
                                      Text(
                                        images[index].dislikes.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                            color: primaryPinkColor,
                                            Icons.delete,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            images[index].delete();
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
