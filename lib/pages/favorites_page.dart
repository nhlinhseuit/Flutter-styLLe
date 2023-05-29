import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stylle/services/notifiers/current_user.dart';

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
    return Scaffold (
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
        body: ImageStreamView(
          user: Provider.of<CurrentUser>(context, listen: false).user, 
          imagesStream: Provider.of<CurrentUser>(context, listen: false).user.favoriteImagesStream()
        ),
      )
    );
  }
}