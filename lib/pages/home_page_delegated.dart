import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/components/page_header.dart';
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
    final currentHour = DateTime.now().hour;
    String greeting;

    if (currentHour < 12) {
      greeting = 'Good morning,';
    } else if (currentHour < 17) {
      greeting = 'Good afternoon,';
    } else {
      greeting = 'Good evening,';
    }

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
              body: ListView(children: [
                Header(
                  firstLine: greeting,
                  secondLine: currentUser.getName,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(_choiceChips[0]),
                        ),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        selected: _selectedChoiceIndex == 0,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChoiceIndex = selected ? 0 : 1;
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
                        selectedColor: Theme.of(context).colorScheme.primary,
                        selected: _selectedChoiceIndex == 1,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChoiceIndex = selected ? 1 : 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _selectedChoiceIndex == 0
                    ? ImageStreamView(
                        user: currentUser, imagesStream: MyImage.imagesStream())
                    : ImageStreamView(
                        user: currentUser,
                        imagesStream: MyImage.imagesPopularStream()),
              ]),
            );
          }
        });
  }
}
