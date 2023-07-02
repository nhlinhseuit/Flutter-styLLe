import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../components/image_stream_viewer.dart';
import '../services/collections/my_images.dart';

class HomePageDelegated extends StatefulWidget {
  const HomePageDelegated({super.key});

  @override
  State<HomePageDelegated> createState() => _HomePageDelegatedState();
}

class _HomePageDelegatedState extends State<HomePageDelegated> {
  late int numberOfItem;
  late final MyUser currentUser;
  int _selectedChoiceIndex = 0;
  final List<String> _choiceChips = ['Newest', 'Popular'];

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
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(
                              0.0), // chiều cao đường kẻ ngang
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 120,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors
                                      .pink[200], // màu sắc của đường kẻ ngang
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 140),
                                color: Colors
                                    .pink[200], // màu sắc của đường kẻ ngang
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
                              Navigator.of(context).pushNamed(searchRoute);
                            },
                          ),
                        ],
                      )
                    ];
                  },
                  body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(_choiceChips[0]),
                                ),
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                selected: _selectedChoiceIndex == 0,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedChoiceIndex = selected ? 0 : -1;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              ChoiceChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(_choiceChips[1]),
                                ),
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                selected: _selectedChoiceIndex == 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedChoiceIndex = selected ? 1 : -1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        _selectedChoiceIndex == 0
                            ? ImageStreamView(
                                user: currentUser,
                                imagesStream: MyImage.imagesStream())
                            : ImageStreamView(
                                user: currentUser,
                                imagesStream: MyImage.imagesPopularStream()),
                      ]),
                ));
          }
        });
  }
}
