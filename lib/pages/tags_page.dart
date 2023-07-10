import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../components/image_stream_viewer.dart';
import '../services/collections/my_images.dart';

class TagsPageDelegate extends StatefulWidget {
  const TagsPageDelegate({super.key});

  @override
  State<TagsPageDelegate> createState() => _TagsPageDelegateState();
}

class _TagsPageDelegateState extends State<TagsPageDelegate> {
  late int numberOfItem;
  late final MyUser currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyImage;
    final tags = args.tags;
    return FutureBuilder(
        future: MyUser.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final MyUser currentUser = snapshot.data!;
            return Scaffold(
                backgroundColor: Colors.white,
                body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        // forceElevated: true,
                        // elevation: 2.5,
                        centerTitle: true,
                        snap: true,
                        floating: true,
                        shadowColor: Colors.black,
                        toolbarHeight: 55,
                        backgroundColor: Colors.white,
                        title: Container(
                          margin: const EdgeInsets.only(bottom: 4, top: 10),
                          child: Text(
                            'styLLe',
                            style: GoogleFonts.allura(
                              color: Colors.pink[200],
                              fontSize: 35,
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: ListView(
                      children: [
                             ImageStreamView(
                                user: currentUser,
                                imagesStream: MyImage.imagesTagsStream(tags))
                      ]),
                ));
          }
        });
  }
}
