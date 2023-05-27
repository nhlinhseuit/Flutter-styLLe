import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../components/image_stream_viewer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyUser.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final MyUser currentUser = snapshot.data!;
          return Scaffold (
            // appBar: AppBar(
            //   title: Text(
            //     'Favorites',
            //     style: GoogleFonts.poppins(
            //       textStyle: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 24.00,
            //       )
            //     ),
            //   ),
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            // ),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text(
                      'Favorites',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 24.00,
                        )
                      ),
                    ),
                    floating: true,
                    backgroundColor: Colors.transparent,
                    forceElevated: innerBoxIsScrolled,
                  ),
                ];
              },
              body: ImageStreamView(currentUser: currentUser, imagesStream: currentUser.favoriteImagesStream()),
            )
          );
        }
      },
    );
  }
}