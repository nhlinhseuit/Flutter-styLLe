import 'dart:core';
import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../components/image_stream_viewer.dart';
import '../components/page_header.dart';
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
    final tags = ModalRoute.of(context)!.settings.arguments as List<String>;
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
              floatingActionButton: Container(
                margin: const EdgeInsets.only(top: 20),
                child: FloatingActionButton.small(
                  elevation: 1,
                  backgroundColor: Colors.white.withOpacity(.2),
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
                  FloatingActionButtonLocation.miniEndTop,
              body: ListView(children: [
                Header(
                  firstLine: "this is",
                  secondLine: tags[0],
                ),
                ImageStreamView(
                    user: currentUser,
                    imagesStream: MyImage.imagesTagsStream(tags))
              ]),
            );
          }
        });
  }
}
