import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:stylle/components/ellipsis_text.dart';
import 'package:stylle/components/image_stream_viewer_short.dart';
import 'package:http/http.dart' as http;
import 'package:stylle/services/collections/my_images.dart';
import '../services/notifiers/current_user.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int numberOfItem = 30;

  // List<String> imgUrls = List.generate(
  //     30,
  //     (index) => index % 2 == 0
  //         ? 'https://picsum.photos/400/400?image=${index + 10}'
  //         : 'https://picsum.photos/300/600?image=${index + 18}');

  Icon firstIcon = Icon(
    color: Colors.pink[200],
    Icons.favorite_rounded,
    size: 30,
  );
  Icon secondIcon = const Icon(
    color: Colors.black,
    size: 30,
    Icons.favorite_border_rounded,
  );
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;
    var isUserFavorite = args.isFavorite;

    // List<String> imgUrlsRelated = List.generate(
    //     30,
    //     (index) => index % 2 == 0
    //         ? 'https://picsum.photos/400/400?image=${index + 10}'
    //         : 'https://picsum.photos/300/600?image=${index + 18}');
    return Consumer<CurrentUser>(builder: (context, currentUser, child) {
      return SafeArea(
        child: Scaffold(
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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                //////////////////////////////       HÌNH RENDER
                Positioned(
                  child: Stack(
                    children: [
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
                    ],
                  ),
                ),

                //////////////////////////////       THAO TÁC TIM, TẢI, COPY, SHARE
                Positioned(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: isUserFavorite ? firstIcon : secondIcon,
                            onPressed: () {
                              currentUser.user.handleFavorite(args);
                              Provider.of<CurrentUser>(context, listen: false)
                                  .userFavorites = currentUser.user.favorites;
                              setState(() {
                                isUserFavorite = !isUserFavorite;
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        Share.shareXFiles([XFile(path2)],
                            text: 'Great picture');
                        // ignore: use_build_context_synchronously
                      },
                    ),
                  ],
                )),

                //////////////////////////////       DIVIDER
                const Divider(
                  height: 1,
                  color: Color(0xbdbdbdbd),
                  thickness: 1.5,
                ),

                //////////////////////////////       INFORMATION IMG
                Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16, top: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(26),
                                    child: CachedNetworkImage(
                                      imageUrl: args.userProfilePic,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                                        color: Colors.black,
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
                    )),

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
            )),
      );
    });
  }
}
