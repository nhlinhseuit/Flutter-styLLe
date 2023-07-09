import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/ellipsis_text.dart';
import 'package:stylle/components/image_stream_viewer_short.dart';
import 'package:http/http.dart' as http;
import 'package:stylle/constants/colors.dart';
import 'package:stylle/services/collections/my_images.dart';
import '../constants/enums.dart';
import '../constants/routes.dart';
import '../services/notifiers/current_user.dart';
import '../utilities/popup_confirm_dialog.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // List<String> imgUrls = List.generate(
  //     30,
  //     (index) => index % 2 == 0
  //         ? 'https://picsum.photos/400/400?image=${index + 10}'
  //         : 'https://picsum.photos/300/600?image=${index + 18}');

  Icon firstIcon = const Icon(
    color: primaryPinkColor,
    Icons.favorite_rounded,
    size: 30,
  );
  Icon secondIcon = const Icon(
    color: Colors.white,
    size: 30,
    Icons.favorite_border_rounded,
  );

  late Icon likeIcon;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;
    var isUserFavorite = args.isFavorite;
    likeIcon = isUserFavorite ? firstIcon : secondIcon;

    // List<String> imgUrlsRelated = List.generate(
    //     30,
    //     (index) => index % 2 == 0
    //         ? 'https://picsum.photos/400/400?image=${index + 10}'
    //         : 'https://picsum.photos/300/600?image=${index + 18}');
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      return Scaffold(
          floatingActionButton: Container(
            margin: const EdgeInsets.only(top: 20),
            child: FloatingActionButton.small(
              elevation: 1,
              backgroundColor: Colors.black.withOpacity(.4),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              //////////////////////////////       HÌNH RENDER

              SizedBox(
                width: double.infinity,
                // height: 610,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(38),
                      bottomRight: Radius.circular(38)),
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              //////////////////////////////       THAO TÁC TIM, TẢI, COPY, SHARE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: isUserFavorite ? firstIcon : secondIcon,
                          onPressed: () async {
                            await currentUser.user.handleFavorite(args);
                            setState(() {
                              Provider.of<CurrentUser>(context, listen: false)
                                  .userFavorites = currentUser.user.favorites;
                            });
                          }),
                      Text(
                        args.likes.toString(),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      try {
                        String path = args.path;
                        await GallerySaver.saveImage(path).then((success) {
                          if (success != null && success) {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      title: Text('Notification'),
                                      content: Text('Download successful'),
                                    ));
                          }
                        });
                      } catch (e) {
                        print('ERROR: $e');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      String path = args.path;
                      await Clipboard.setData(ClipboardData(text: path));
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: Text('Notification'),
                                content: Text('Copy successful'),
                              ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      String path = args.path;
                      // await Share.share(path, subject: "subject that I like");

                      // ignore: use_build_context_synchronously

                      final uri = Uri.parse(path);
                      final response = await http.get(uri);
                      final bytes = response.bodyBytes;
                      final temp = await getTemporaryDirectory();
                      final path2 = '${temp.path}/sharedImag.jpg';
                      File(path2).writeAsBytesSync(bytes);
                      Share.shareXFiles([XFile(path2)], text: 'Great picture');
                      // ignore: use_build_context_synchronously
                    },
                  ),
                  if (args.userID == currentUser.user.uid)
                    PopupMenuButton<MyImageAction>(
                      color: Colors.white,
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
                    }, onSelected: (value) async {
                      switch (value) {
                        case MyImageAction.update:
                          Navigator.of(context)
                              .popAndPushNamed(editImageRoute, arguments: args);
                          break;
                        case MyImageAction.delete:
                          final confirmLogout = await showLogOutDialog(context,
                              content:
                                  'Delete this image?\nThis action cannot be revert.',
                              title: 'Delete');
                          if (confirmLogout) {
                            args.delete();
                            Navigator.of(context).pop();
                          }
                      }
                    })
                ],
              ),

              //////////////////////////////       DIVIDER
              const Divider(
                height: 1,
                color: Color(0xbdbdbdbd),
                thickness: 1.5,
              ),

              //////////////////////////////       INFORMATION IMG
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleImage(
                              size: 52, imgUrl: args.userProfilePic),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            args.userName,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 28, right: 20, top: 8, bottom: 8),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: EllipsisText(
                        maxLines: 4,
                        text: args.description,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: args.tags.isNotEmpty
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.tag,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                Text(
                                  args.tags.join(", "),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),

              //////////////////////////////       DIVIDER
              const Divider(
                height: 1,
                color: Color(0xbdbdbdbd),
                thickness: 1.5,
              ),

              //////////////////////////////       RELATED PHOTOS TITLE
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                child: const Text(
                  'Related photos',
                  style: TextStyle(
                    color: Color.fromARGB(255, 183, 183, 183),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              //////////////////////////////
              /// RELATED PHOTOS IMGS
              ImageStreamViewShort(imagesStream: args.getRelatedImages())
            ]),
          ));
    });
  }
}
