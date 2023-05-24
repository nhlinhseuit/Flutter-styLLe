import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/components/infinite_scrollable_image_list.dart';

class HomePageDelegated extends StatefulWidget {
  const HomePageDelegated({super.key});

  @override
  State<HomePageDelegated> createState() => _HomePageDelegatedState();
}

class _HomePageDelegatedState extends State<HomePageDelegated> {
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
    return FutureBuilder(
      future: MyUser.getCurrentUser(),
      builder:(context, snapshot)  {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
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
                  bottom: PreferredSize(
                    preferredSize:
                        const Size.fromHeight(0.0), // chiều cao đường kẻ ngang
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 120,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.pink[200], // màu sắc của đường kẻ ngang
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 140),
                          color: Colors.pink[200], // màu sắc của đường kẻ ngang
                          height: 1.0, // độ dày của đường kẻ ngang
                        ),
                      ),
                    ),
                  ),
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
                  actions: <Widget>[
                    IconButton(
                      color: Colors.pink[200],
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 28.0,
                      ),
                      onPressed: () {
                        // handle search action here
                      },
                    ),
                  ],
                )
              ];
            },
            body: Stack(
              children: [
                InfiniteScrollableImageList(currentUser: currentUser),
              ]
            ),
          ));
        }
      }
    );
  }
}
